class VideosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create]
	def create
		@video = LibraryVideo.new(video_params)
	  	respond_to do |format|
	      if @video.save
	      	p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      		@video.update_attributes(panda_video_id: p_video.id)
      		
      				
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
