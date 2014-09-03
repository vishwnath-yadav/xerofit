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

  def status_mail_to_admin(object, user)
    @object = object
    @user = user
    mail(to: @user, subject: "Mail for approve the Workout")
  end

  def full_wkt_uploaded_success(video, user)
    @video = video
    @user = user
    mail(to: @user, subject: "New Full Workout has been uploaded")
  end
end
