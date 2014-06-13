class Emailer < ActionMailer::Base
  default from: "Admin@Xerofit.com"

  def user_registration_mail(email)
  	@email = email
    mail(to: email, subject: "Thanks for showing interest in Xerofit")
  end
end
