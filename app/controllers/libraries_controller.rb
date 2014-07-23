class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :library, :title, :full => true
	def index
		@libraries = Library.where(user_id: current_user.id).order('created_at DESC').page(params[:page]).per(5)
	end
	
	def new
		@library = Library.new
		@libvideo = LibraryVideo.new
		@library.build_association
	end
	
	def edit
		@library = Library.find(params[:id])
		@size = @library.library_video.panda_mp4.screenshots
	end
	
	def create
	  @library = Library.new(library_params)
	  @library.user_id = current_user.id
	  @video_id = params[:video]
	  if @library.save
	  	video = LibraryVideo.find(@video_id)
	  	video.library = @library
	  	video.save
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
		respond_to do |format|
	      if @library.update_attributes(library_params)
	        format.html { redirect_to libraries_path, notice: 'successfully updated prescription.' }
	        format.json { head :no_content }
	      else
	        format.html { render action: "edit" }
	        format.json { render json: @library.errors, status: :unprocessable_entity }
	      end
    	end
	end

	def get_lib_items
		@view = params[:view_type]
		status = params[:status]
		if params[:type] == "Excercises"
			@libraries = Library.where(:user_id => current_user, :status => params[:status])
		elsif params[:type] == "Workouts"
			@workouts = Workout.where(:user_id => current_user)
		end
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
		  @libraries = Library.where(user_id: current_user.id).page(params[:page]).per(5).order('title ASC')
		elsif params[:val] == 'Date'
		  @libraries = Library.where(user_id: current_user.id).page(params[:page]).per(5).order('created_at DESC')
		end
		respond_to do |format|
	        format.js
        end
	end

	def see_more_thumbnail
	end

	private
	  def library_params
	    params.require(:library).permit!
	  end
end
