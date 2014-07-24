class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :library, :title, :full => true
	def index
		@libraries = Library.where(user_id: current_user.id).order('created_at DESC').page(params[:page]).per(16)
		@list = Library.where(user_id: current_user.id).order('created_at DESC').page(params[:page]).per(16)
	end
	
	def new
		@library = Library.new
		@libvideo = LibraryVideo.new
		@library.build_association
	end
	
	def edit
		@library = Library.find(params[:id])
		if @library.library_video.present?
			@size = @library.library_video.panda_mp4.screenshots
		end
	end
	
	def create
	  @library = Library.new(library_params)
	  @library.user_id = current_user.id
	  @video_id = params[:video]
	  if @library.save
	  	video = LibraryVideo.find(@video_id)
	  	# video.image = video.panda_mp4.screenshots[0]
	  	video.library = @library
	  	video.save
	  	Rails.logger.debug video.inspect
	    redirect_to libraries_path, :notice => "Thank you for uploading video!"
	  else
	  	@libvideo = LibraryVideo.new
	    render :new
	  end
	end

	def show
		@library = Library.find(params[:id])
	end

	def update
		@library = Library.find(params[:id])
		@video = @library.library_video.update_attributes(:image => params[:image])
		if params[:status_change] == Library::STATUS[1]
			respond_to do |format|
		      if @library.update_attributes(library_params)
		      	@library.status = Library::STATUS[1] 
		      	@library.save
		        format.html { redirect_to libraries_path, notice: 'successfully updated Library.' }
		        format.json { head :no_content }
		      else
		        format.html { render action: "edit" }
		        format.json { render json: @library.errors, status: :unprocessable_entity }
		      end
		  	end
		else
			respond_to do |format|
		      if @library.update_attributes(library_params)
		        format.html { redirect_to libraries_path, notice: 'successfully updated Library.' }
		        format.json { head :no_content }
		      else
		        format.html { render action: "edit" }
		        format.json { render json: @library.errors, status: :unprocessable_entity }
		      end
		  	end
	    end
	end

	def get_lib_items
		@view = params[:view_type]
		status = params[:status]
		name = params[:title]
		@list = []
		if params[:type] == "Workouts"
			@list = Workout.by_name(name).by_status(status).where(:user_id => current_user, state: :completed)
		elsif params[:type] == "Excercises"
			@list = Library.by_name(name).by_status(status).where(:user_id => current_user)
		else
			@list = Workout.by_name(name).by_status(status).where(:user_id => current_user, state: :completed)
			@list << Library.by_name(name).by_status(status).where(:user_id => current_user)
		end

		@list = @list.flatten
		respond_to do |format|
			format.js
		end
	end 

	def library_search_by_name
		@view = params[:type]
		if params[:name].present?
			@libraries = Library.where(user_id: current_user, title: params[:name])
		else
			@libraries = Library.where(user_id: current_user)
		end
		respond_to do |format|
			format.js
		end
	end

	def sort_video
		if params[:val] == 'Name'
		  @libraries = Library.where(user_id: current_user.id).page(params[:page]).per(16).order('title ASC')
		elsif params[:val] == 'Date'
		  @libraries = Library.where(user_id: current_user.id).page(params[:page]).per(16).order('created_at DESC')
		end
		respond_to do |format|
	        format.js
        end
	end

	def see_more_thumbnail
	end

	def destroy
		@library = Library.find(params[:id])
		@library.destroy
		redirect_to libraries_path
	end

	private
	  def library_params
	    params.require(:library).permit!
	  end
end
