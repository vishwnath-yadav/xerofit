class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :libraries 
  has_many :workout_builders
   ROLES = %w[admin trainer normaluser]

   validates :role, presence: true

  User::ROLES.each do |role|
    # define methods such as student?, admin? etc.
    define_method "#{role}?" do
      self.role == role
    end
  end


  def active_for_authentication?
    super && self.enabled
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

end
