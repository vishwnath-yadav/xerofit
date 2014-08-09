class VideosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create]
	
	respond_to :json, :js
	def create
		binding.pry
	  	if session[:video_id].blank?
			@video = LibraryVideo.new(video: params[:file]) 
	    else
	    	@video = LibraryVideo.find(session[:video_id])
	    	@video.image = ''
	    end
	    if @video.save
	  		p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
	  		@video.panda_video_id = p_video.id
	  		if @video.library_id.present?
	  			@video.library_id = params[:lib_id]
	  		end
	  		@video.save
	    end
    	render text: "#{@video.present? ? @video.id : ""}"
	end

	def destroy
		@video = LibraryVideo.find(params[:id])
		@video.destroy
		redirect_to :back
	end

	private
	def video_params
        params.require(:library_video).permit(:video)
    end
end
