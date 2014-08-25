class User < ActiveRecord::Base
  require 'RMagick'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :x, :y, :width, :height, :cropper_id

  #has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :pic, :styles => { :display => '300x200', :medium => "300x300>"}, 
                          :whiny_thumbnails => true, :path => 
                          ":rails_root/public/system/:attachment/:id/:style/:style.:extension", 
                          :url => "/system/:attachment/:id/:style/:style.:extension"

  validates_attachment_content_type :pic, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates :pic, :dimensions => { :width => 300, :height => 300 }, :on => :create, :if => "!pic.blank?"
    

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :libraries 
  has_many :addresses
  has_many :subscriptions
  accepts_nested_attributes_for :addresses, :subscriptions
  has_many :workouts
  
  before_create :generate_token

  ROLES = %w[admin trainer normaluser]
  ROLESFORADMIN = %w[trainer normaluser]

  validates :role, presence: true

  scope :by_email, lambda { |email| where('email ilike ?', email+"%") unless email.blank? }
  scope :by_role, lambda { |role| where(role: role) unless role.blank? }

  User::ROLES.each do |role|
    # define methods such as student?, admin? etc.
    define_method "#{role}?" do
      self.role == role
    end
  end

  def build_association
    1.times{addresses.build if self.addresses.empty? }
    1.times{subscriptions.build if self.subscriptions.empty? }
  end


  def active_for_authentication?
    super && self.enabled
  end

  def day
    self.date_of_birth.present? ? self.date_of_birth.day : 0
  end

  def month
    self.date_of_birth.present? ? self.date_of_birth.month : 0
  end

  def year
    self.date_of_birth.present? ? self.date_of_birth.year : 0
  end

  def dob(day, month, year)
    if !day.blank? && !month.blank? && !year.blank?
      self.date_of_birth = Date.strptime("#{day}/#{month}/#{year}", '%m/%d/%Y')
      self.save
    end
  end

  def inactive_message
    self.enabled ? super : :account_disabled
  end

  def self.from_omniauth(auth)
    @user = User.where(:email=>auth.info.email).last
    if !@user.present?
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.fullname = auth.info.name
        user.role = "normaluser"
        user.enabled = false
        user.skip_confirmation!   # assuming the user model has a name
        user.save(:validate => false)
        Emailer.user_registration_mail(user.email).deliver
        @user = user
      end
    else
      @user.provider = auth.provider
      @user.uid = auth.uid
      @user.save(:validate => false)
    end
    return @user
  end
  
  def self.admin_count
    self.all.where(role: 'admin').count
  end

  def self.trainer_count
    self.all.where(role: 'trainer').count
  end

  def self.user_count
    self.all.where(role: 'normaluser').count
  end

  def update_photo_attributes(att)
    scaled_img = Magick::ImageList.new(self.pic.path)
    orig_img = Magick::ImageList.new(self.pic.path(:display))
    scale = orig_img.columns.to_f / scaled_img.columns
    args = [ att[:x1], att[:y1], att[:width], att[:height] ]
    args = args.collect { |a| a.to_i * scale }
    orig_img.crop!(*args)
    orig_img.write(self.pic.path(:display))
    self.pic.reprocess!
    self.save
  end

  protected

  def generate_token
    token = SecureRandom.urlsafe_base64(self.id, false)
    self.token = token[0, 8]
  end

end
