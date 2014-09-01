require 'RMagick'
include Magick
class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :move, :title, :full => true
	# layout :resolve_layout    

	def index
		@order = params[:order].blank? || params[:order] == "DESC" ? "ASC" : "DESC"
		@sort_arrow = params[:sort_arrow].blank? ? 'descending' : params[:sort_arrow]
		@view = params[:view_type].present? ? params[:view_type] : 'grid'
		user = User.where(token: params[:id]).last
		@list1 = Move.get_library_list(params,current_user,user)
		@list = Kaminari.paginate_array(@list1).page(params[:page]).per(12)
		respond_to do |format|
			format.js
			format.html
		end
	end
	
	def new
		session[:video_id] = ''
		@library = Move.new
		@libvideo = LibraryVideo.new
		@max_size_allowed = 250
		5.times { @library.target_muscle_groups.build }
	end
	
	def edit
		@library = Move.find(params[:id])
		@disabled = ([@library.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = @library.is_full_workout ? 1024 : 250
		@size = @library.get_thumbnail()
		@count = @library.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @count!=5)
	end
	
	def create
		binding.pry
	  @video_id = params[:video]
	  video = LibraryVideo.find(@video_id)
	  if params[:move][:title].blank? && params[:move][:is_full_workout].blank?
	  	params[:move][:title] = video.video_title.split(".")[0]
	  elsif params[:move][:title].blank?
	  	params[:move][:title] = video[:video].split(".")[0]
	  end 	
	  @library = Move.new(library_params)
	  @library.user_id = current_user.id
	  if @library.save
	  	video.move = @library
	  	video.save
	  	if !params[:move][:is_full_workout].blank?
	    	redirect_to libraries_path, :notice => "Workout uploaded successfully. We'll let you know when it gets edited and added to your account"
	    else
	    	redirect_to libraries_path, :notice => "Thank you for uploading the video."
	  	end
	  else
	  	@libvideo = LibraryVideo.new
	    render :new
	  end
	end

	def show
		@library = Move.find(params[:id])
	end

	def update
		@library = Move.find(params[:id])
		if params[:image].present?
			@video = @library.library_video.update_attributes(:image => params[:image])
		end
		@library.update_target_muscle(params[:move][:target_muscle_groups_attributes])
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
			@libraries = Move.by_name(title).where(user_id: current_user.id).order('title asc')
		else
			@libraries = Move.by_name(title).where(user_id: current_user.id).order('title DESC')
		end
		respond_to do |format|
			format.js 
		end
	end

	def library_search_by_name
		@view = params[:type]
		if params[:name].present?
			@libraries = Move.where(user_id: current_user, title: params[:name])
		else
			@libraries = Move.where(user_id: current_user)
		end
		respond_to do |format|
			format.js
		end
	end

	def sort_video
		if params[:val] == 'Name'
		  @libraries = Move.where(user_id: current_user.id).page(params[:page]).per(16).order('title ASC')
		elsif params[:val] == 'Date'
		  @libraries = Move.where(user_id: current_user.id).page(params[:page]).per(16).order('created_at DESC')
		end
		respond_to do |format|
      format.js
    end
	end

	def see_more_thumbnail
	end

	def destroy
		@library = Move.find(params[:id])
		@library.destroy
		redirect_to libraries_path
	end

	def full_workout_content
		session[:video_id] = !params[:video_id].blank? ? params[:video_id] : ''
		if params[:popup].blank?
			@max_size_allowed = 250
		elsif !session[:video_id].blank?
			video = LibraryVideo.find_by_id(session[:video_id])
			@max_size_allowed = video.move.is_full_workout ? 1024 : 250
		else
			@max_size_allowed = 1024
		end
		respond_to do |format|
		    format.js
	    end
	end

	respond_to :json, :js
	def crop_image_save
		# binding.pry
		if params[:type] == "workout"
			param = params[:workout]
			@obj = Workout.find_by_id(params[:id])
			obj_param = workout_params
		else
			param = params[:user]
			@obj = User.find_by_id(params[:id])
			obj_param = user_params
		end
		if(param[:crop_x] && param[:crop_y] && param[:crop_w] && param[:crop_h])
	        if(@obj.update_attributes(obj_param))
	          @obj.reprocess_pic
	        end
    	end
    	respond_to do |format|
		    format.js
	    end
	end

	# def crop_image_save
	#   @user = current_user
 #    respond_to do |format|
 #      if(params[:user][:crop_x] && params[:user][:crop_y] && params[:user][:crop_w] && params[:user][:crop_h])
 #        if(@user.update_attributes(user_params))
 #          @user.reprocess_pic
 #        end
 #    	end
 #        format.html { redirect_to settings_crop_image_test_path }
 #        format.json { render json: @user.errors, status: :unprocessable_entity }
 #    end
	# end

	private
	  def library_params
	    params.require(:move).permit!
	  end

	  def user_params
	    params.require(:user).permit!
	  end

	  def workout_params
	    params.require(:workout).permit!
	  end

  	
end
