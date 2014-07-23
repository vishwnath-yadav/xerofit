class VideosController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create]
	def create
		@video = LibraryVideo.new(video_params)
		if !params[:video_old_id].present?
		  	respond_to do |format|
		      if @video.save
		      	Rails.logger.debug ">>>>>>>"
	      		p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
	      		@video.update_attributes(panda_video_id: p_video.id)
	      		# @video.update_attributes(image: @video.panda_mp4.screenshots[0])
	      		if params[:lib_id].present?
	      			@video.update_attributes(library_id: params[:lib_id])
	      		end
		        format.js
		      end
	    	end
	    else
	    	@video = LibraryVideo.find(params[:video_old_id])
	    	respond_to do |format|
		      if @video.save
	      		p_video = Panda::Video.create!(source_url: @video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
	      		@video.update_attributes(panda_video_id: p_video.id)
	      		Rails.logger.debug @video.inspect
	      		if library.present?
	      			@video.update_attributes(library_id: library.id)
	      		end
		        format.js
	    	end
	    end
	end

	def destroy
		@video = LibraryVideo.find(params[:id])
		@video.destroy
		redirect_to :back
	end

	# def update
	# 	Rails.logger.debug ">>>>>>>>>>>>"
	# 	# @library = Library.find(params[:id])
	# 	# if @library.library_video.present?

	# 	# else
	# 	# end
	# 	redirect_to :back
	# end

	private
	def video_params
        params.require(:library_video).permit(:video)
    end
end
