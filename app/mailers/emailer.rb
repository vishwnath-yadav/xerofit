class Emailer < ActionMailer::Base
  default from: "Admin@Xerofit.com"

  def user_registration_mail(email)
  	@email = email
    mail(to: email, subject: "Thanks for showing interest in Xerofit")
  end

  def send_lib_status_change_mail(email, msg, title, status)
  	@message = msg
  	@status = status
  	@title = title
  	@email = email
    mail(to: email, subject: "Your library Status has been updated")
  end
end
