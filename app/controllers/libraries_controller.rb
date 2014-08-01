class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :library, :title, :full => true
	def index
		@libraries = Library.where(user_id: current_user.id).order('created_at DESC').page(params[:page]).per(16)
		@list = Library.where(user_id: current_user.id)
		@list << Workout.where(:user_id => current_user, state: :completed)
		@list = @list.order('created_at DESC').page(params[:page]).per(16).flatten
		# @list = Library.list_view("","","",current_user)
		# @list = @list.order('created_at DESC').page(params[:page]).per(16).flatten
		
	end
	
	def new
		@library = Library.new
		@libvideo = LibraryVideo.new
		5.times { @library.target_muscle_groups.build }
	end
	
	def edit
		@library = Library.find(params[:id])
		if @library.library_video.present?
			size = @library.library_video.panda_mp4.screenshots
			@image = @library.library_video.image
			if size.include?(@image)
				index = size.index(@image)
				temp = size[index]
				size[index] = size[0]
				size[0] = temp
			end
			@size = size	
		end
		@size.size > 6 ? @size.pop() : @size
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @library.target_muscle_groups.present?)
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
		@library.update_target_muscle(params[:library][:target_muscle_groups_attributes])
		respond_to do |format|
		    if @library.update_attributes(library_params)
		        format.html { redirect_to edit_library_path(@library), notice: 'successfully updated Library.' }
		    else
		        format.html { render action: "edit" }
		    end
	    end
	end


	def filter
		filter_order = params[:filter]
		title = params[:title]
		if filter_order == 'asc'
			@libraries = Library.by_name(title).where(user_id: current_user.id).order('title asc')
		else
			@libraries = Library.by_name(title).where(user_id: current_user.id).order('title DESC')
		end
		respond_to do |format|
			format.js 
		end
	end

	def get_lib_items
		@view = params[:view_type]
		status = params[:status]
		name = params[:title]
		type = params[:type]
		@list = Library.list_view(status,name,type,current_user).flatten
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
