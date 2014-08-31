class Emailer < ActionMailer::Base
  #default from: "support@xerofit.com"

  def user_registration_mail(email)
  	@email = email
    mail(to: email, subject: "Thanks for showing interest in Xerofit")
  end

  def send_lib_status_change_mail(email, msg, title, status, model)
  	@message = msg
  	@status = status
  	@title = title
  	@email = email
    @model = model
    mail(to: email, subject: "Your #{model} Status has been updated")
  end
end
