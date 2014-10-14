class VideosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create,:full_workout]
	
	respond_to :json, :js
	def create
  	if session[:video_id].blank?
		  @video = LibraryVideo.new(video: params[:file]) 
    else
    	@video = LibraryVideo.find(session[:video_id])
    	@video.image = ''
    end
    if @video.save
      p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      @video.panda_video_id = p_video.id
      @video.save
  			# update_scheduled_date = Time.now + 20
     #    logger.debug(">>>>>>>>>>>>>>>>job work starting>>>>>>>>>>>>>>")
     #    delayed_job = Delayed::Job.enqueue(PandaVideoUpload.new(@video.id), 0, update_scheduled_date)
     #    logger.debug(">>>>>>>>>>>>>>>>job work end>>>>>>>>>>>>>>")
    end
  	render text: "#{@video.present? ? @video.id : ""}"
	end

	def destroy
		@video = LibraryVideo.find(params[:id])
		@video.destroy
		redirect_to :back
	end

  def full_workout
    @user = params[:user].blank? ? current_user : User.find_by_token(params[:user])
    @video = FullWorkout.new(video: params[:file], user_id: @user.id)
    @video.save
    user = User.where(:role=> "admin").pluck(:email)
    if user.present?
      Emailer.full_wkt_uploaded_success(@video,user).deliver
    end
    render json: {user: params[:user]}
  end

	private
	def video_params
    params.require(:library_video).permit(:video)
  end
end
