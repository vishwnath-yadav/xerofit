require 'RMagick'
include Magick
class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	before_action :fetch_user, except: [:crop_image_save]
	autocomplete :move, :title, :full => true

	def index
		@order = params[:order].blank? || params[:order] == "DESC" ? "ASC" : "DESC"
		@sort_arrow = params[:sort_arrow].blank? ? 'descending' : params[:sort_arrow]
		@view = params[:view_type].present? ? params[:view_type] : 'grid'
		@list1 = Move.get_library_list(params,current_user,@user)
		@move = Kaminari.paginate_array(@list1).page(params[:page]).per(12)
		respond_to do |format|
			format.js
			format.html
		end
	end
	
	def new
		session[:video_id] = ''
		@move = Move.new
		@libvideo = LibraryVideo.new
		@max_size_allowed = 250
		5.times { @move.target_muscle_groups.build }
	end
	
	def edit
		@move = Move.find(params[:id])
		@disabled = ([@move.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = 1024
		@size = @move.get_thumbnail()
		@count = @move.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@move.title.present? && @move.directions.present? && @move.category.present? && @move.difficulty.present? && @move.library_video.image.present? && @count!=5)
	end
	
	def create
	  logger.debug(">>>>>>>>>>>>>>>>>>>>>>>")
	  @video_id = params[:video]
	  video = LibraryVideo.find(@video_id)
	  logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>")
	  if params[:move][:title].blank?
	  	params[:move][:title] = video.video_title.split(".")[0]
	  end
	  @move = Move.new(library_params)
	  @move.user_id = @user.id
	  if @move.save
	  	logger.debug("dd*********************")
	  	video.delay(:queue => 'saving_video_id').update_attributes(move_id: @move.id)
	  	# video.update_attributes(move_id: @move.id)
	  	logger.debug("ddddddddddddddddddddddddd")
	  	@move.history_create()
	  	logger.debug("dddddddddddd>>>>>>>>>>>>>>>>>>>>>ddddddddddddd")
	  	if current_user.admin?
	  		logger.debug(">>>>>>>>>>>>>>>>>>>>>>sdfdsfdfsd>>")
    		redirect_to libraries_path(user: @user.token), :notice => "New move has been saved to your Fitness Library"
    	else
	  		logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>")
    		redirect_to libraries_path, :notice => "New move has been saved to your Fitness Library"
    	end
	  else
	  	@libvideo = LibraryVideo.new
	    render :new
	  end
	end

	def update
		@move = Move.find(params[:id])
		if params[:image].present?
			@video = @move.library_video.update_attributes(:image => params[:image])
		end
		@move.update_target_muscle(params[:move][:target_muscle_groups_attributes])
		respond_to do |format|
			old_status = @move.status
		    @move.update_attributes(library_params)
			@move.date_updated_for_approval(params[:move][:status], old_status)
	        if current_user.admin?
	        	format.html { redirect_to libraries_path(user: @move.user.token), notice: 'Your changes have been saved' }
	        else
	        	format.html { redirect_to libraries_path, notice: 'Your changes have been saved' }
		    end
	    end
	end

	def filter
		filter_order = params[:filter]
		title = params[:title]
		enabled_move = []
		disabled_move = []
		# if filter_order == 'asc'
			@moves = Move.by_name(title).where(user_id: @user.id).order('title asc')
		# else
			# @moves = Move.by_name(title).where(user_id: @user.id).order('title DESC')
		# end
		if @moves.present?
			@moves.each do |move|
				res = move.has_full_detail
				if res == true
					enabled_move << move
				else
					disabled_move << move
				end
			end
			@enabled_move = enabled_move.flatten.sort_by(&:title)
			@disabled_move = disabled_move.flatten.sort_by(&:title)
		end
		respond_to do |format|
			format.js 
		end
	end

	def destroy
		@move = Move.find(params[:id])
		@move.destroy
		redirect_to libraries_path
	end

	def full_workout_content
		session[:video_id] = !params[:video_id].blank? ? params[:video_id] : ''
		if params[:popup].blank?
			@max_size_allowed = 250
		elsif !session[:video_id].blank?
			video = LibraryVideo.find_by_id(session[:video_id])
			@max_size_allowed = 250
		else
			@max_size_allowed = 1024
		end
		respond_to do |format|
		    format.js
	    end
	end

	def image_test
		
	end

	respond_to :json, :js
	def crop_image_save
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
