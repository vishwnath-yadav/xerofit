class User < ActiveRecord::Base
  require 'RMagick'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :pic_creating


  has_attached_file :pic, :styles => { :small => "100x100#", :medium => "300x300#",:large => "500x500>" }, :processors => [:cropper]
  has_many :moves 
  has_many :full_workouts 
  has_many :addresses
  has_many :subscriptions
  has_many :workouts
  
  before_create :generate_token
  # after_update :reprocess_pic, :if => :cropping? 

  ROLES = %w[admin trainer normaluser]
  ROLESFORADMIN = %w[trainer normaluser]

  USER_TYPE = [["Date Registered","created_at"],["ID","id"],["Email","email"],["First Name","first_name"],["Last Name","last_name"]]
  USER_TRASH_TYPE = [["Date Trashed","updated_at"],["ID","id"],["Email","email"],["User Role","role"]]

  validates :role, presence: true
  validates_attachment_content_type :pic, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates :pic, :dimensions => { :width => 300, :height => 300 }, if: :validate_image
  
  accepts_nested_attributes_for :addresses, :subscriptions

  scope :by_email, lambda { |email| where('email ilike ?', email+"%") unless email.blank? }
  scope :by_role, lambda { |role| where(role: role) unless role.blank? }
  scope :by_name, lambda { |name| where('lower(first_name) LIKE lower(?) OR lower(last_name) LIKE lower(?)', "%#{name}%", "%#{name}%") unless name.blank? }
  User::ROLES.each do |role|
    # define methods such as student?, admin? etc.
    define_method "#{role}?" do
      self.role == role
    end
  end

  def min_image_size
    "300x300"
  end

  def build_association
    1.times{addresses.build if self.addresses.empty? }
    1.times{subscriptions.build if self.subscriptions.empty? }
  end


  def active_for_authentication?
    super && self.enabled
  end

  def single_moves
    self.moves
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
    self.where(role: 'admin').count
  end

  def self.trainer_count
    self.where(role: 'trainer').count
  end

  def self.user_count
    self.where(role: 'normaluser').count
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def pic_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(pic.path(style))
  end
  
  def reprocess_pic
    pic.reprocess!
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  protected

  def generate_token
    token = SecureRandom.urlsafe_base64(self.id, false)
    self.token = token[0, 8]
  end

  def validate_image
      self.pic? && !self.pic_creating.blank?
  end

end
