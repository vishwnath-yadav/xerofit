class VideosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create]
	def create
		@video = LibraryVideo.new(video_params)
	  	respond_to do |format|
	      if @video.save
	      	# p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      		# @video.update_attributes(panda_video_id: p_video.id)
      		update_scheduled_date = Time.now + 20
      		delayed_job = Delayed::Job.enqueue(PandaVideoUpload.new(@video.id), 0, update_scheduled_date)
      				
	        format.js
	      else
	        format.js { render json: @library.errors, status: :unprocessable_entity }
	      end
    	end
	end

	private
	def video_params
        params.require(:library_video).permit(:video)
    end
end
