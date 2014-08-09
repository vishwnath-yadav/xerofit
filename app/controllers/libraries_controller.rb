class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :library, :title, :full => true
	layout :resolve_layout    

	def index
		@view = params[:view_type]
		user = User.where(token: params[:id]).last
		@list1 = Library.get_library_list(params[:status],params[:title],params[:type],current_user,user)
		@list = Kaminari.paginate_array(@list1).page(params[:page]).per(12)
		respond_to do |format|
				format.js
				format.html
		end
	end
	
	def new
		session[:video_id] = ''
		@library = Library.new
		@libvideo = LibraryVideo.new
		@max_size_allowed = 250
		5.times { @library.target_muscle_groups.build }
	end
	
	def edit
		@library = Library.find(params[:id])
		@max_size_allowed = @library.is_full_workout ? 1024 : 250
		@size = @library.get_thumbnail()
		@count = @library.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @count!=5)
	end
	
	def create
	  @video_id = params[:video]
	  video = LibraryVideo.find(@video_id)
	  if params[:library][:title].blank?
	  	params[:library][:title] = video.video_title
	  end 	
	  @library = Library.new(library_params)
	  @library.user_id = current_user.id
	  if @library.save
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
		if params[:image].present?
			@video = @library.library_video.update_attributes(:image => params[:image])
		end
		@library.update_target_muscle(params[:library][:target_muscle_groups_attributes])
		if params[:status] == Library::STATUS[1]
			@library.status = Library::STATUS[1]	
		end
		respond_to do |format|
		    if @library.update_attributes(library_params)
		        format.html { redirect_to edit_path(@library), notice: 'successfully updated Library.' }
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

	def full_workout_content
		session[:video_id] = !params[:video_id].blank? ? params[:video_id] : ''
		if params[:popup].blank?
			@max_size_allowed = 250
		elsif !session[:video_id].blank?
			video = LibraryVideo.find_by_id(session[:video_id])
			@max_size_allowed = video.library.is_full_workout ? 1024 : 250
		else
			@max_size_allowed = 1024
		end
		respond_to do |format|
		    format.js
	    end
	end

	private
	  def library_params
	    params.require(:library).permit!
	  end

  	
end
