class Emailer < ActionMailer::Base
  default from: "support@xerofit.com"

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

  def status_mail_to_admin(object, emails)
    @object = object
    mail(to: emails, subject: "Mail for approve the Workout")
  end

  def full_wkt_uploaded_success(video, user)
    @video = video
    @user = user
    mail(to: @user, subject: "New Full Workout uploaded")
  end

  def uncut_workout_mail_to_user(params, user)
    @user = user
    @message = params[:message]
    mail(to: user.email, subject: params[:subject])
  end

  def approve_mail_to_user(user,params)
    @user = user
    @message = params[:message]
    mail(to: user.email, subject: params[:subject])
  end
end
