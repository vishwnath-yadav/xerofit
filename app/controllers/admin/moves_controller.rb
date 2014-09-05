class Admin::MovesController < Admin::AdminController

	def index
		@sort_array = Move::ADMIN_MOVE_FILTER
		parm = params.merge({type: Move::TYPE[0]}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end 

	def edit
		@library = Move.find(params[:id])
		@disabled = ([@library.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = 250
		@size = @library.get_thumbnail()
		@count = @library.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @count!=5)
	end

	def destroy
	    @move = Move.find(params[:id])
	    @move.destroy
	    redirect_to :back
    end

	def uncut_workout
		@sort_array = Move::ADMIN_UNCUT_FILTER
		parm = params.merge({type: Move::TYPE[0]}) 
		# @moves = Move.get_library_list(parm,current_user,'')
		@moves = FullWorkout.where(mark_complete: false, enable: true).order('updated_at desc')
	end

	def approval_page
		@sort_array = Move::ADMIN_APPROVE_FILTER
		parm = params.merge({status: Move::STATUS[2], sorted_by: "date_submitted_for_approval", order: "ASC"}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def admin_filter
		if params[:action_name] == "uncut_workout"
			@moves = FullWorkout.get_workout_list(params,current_user)
		else
			@moves = Move.get_library_list(params,current_user,'')
		end
	end

	def mark_complete
		move = FullWorkout.find(params[:id])
		move.mark_complete = params[:mark_as] == 'true' ? true : false
		move.save
		render nothing: true
	end

	def status_approve
		if params[:type] == Move::TYPE[0]
			move = Move.find_by_id(params[:id])
		else
			move = Workout.find_by_id(params[:id])
		end
		move.status = params[:status]
		if move.status == Move::STATUS[2]
			move.date_submitted_for_approval = move.updated_at
		end		
		move.save
		render nothing: true
	end

	def uncut_workout_mail
		full_workout = FullWorkout.find(params[:id])
		user = full_workout.user
		Emailer.uncut_workout_mail_to_user(params,user).deliver
		render nothing: true
	end

	def download_video
		url = params[:url]
		new_file_path = "#{Rails.root.to_s}/public/your_video2.mp4"
		open(new_file_path, "wb") do |file| 
		  file.print open(url).read
		end
		render nothing: true
	end

	def trash_page
		@sort_array = Move::ADMIN_TRASH_FILTER
		parm = params.merge({enable: true}) 
		@moves = Move.get_library_list(parm,current_user,'')
		@full_workouts = FullWorkout.where(enable: false)
		@users = User.where(enabled: false)
	end

	def trash
		if params[:type] == Move::TYPE[0]
			@move = Move.find(params[:id])
		else
			@move = Workout.find(params[:id])
		end
		@move.enable = false
		@move.save
		redirect_to :back
	end

	def restore
		if params[:type] == Move::TYPE[0]
			@move = Move.find(params[:id])
		else
			@move = Workout.find(params[:id])
		end
		@move.enable = true
		@move.save
		redirect_to :back
	end

	def admin_approve_workout_mail
		if params[:type] == Move::TYPE[0]
			move = Move.find_by_id(params[:id])
		else
			move = Workout.find_by_id(params[:id])
		end	
		usr = move.user
		Emailer.approve_mail_to_user(usr,params).deliver
		render nothing: true
	end

	def admin_trash
		if params[:text] == "User Trash"
			user = User.where(enabled: false)
			render partial: "common_templates/admin/user_trash_content_table", locals: {users: user}
		elsif params[:text] == "Uncut Workout Trash"
			move = FullWorkout.where(enable: true)
			render partial: "common_templates/admin/uncut_workout_content_table", locals: {moves: move}
		else
			parm = params.merge({enable: true}) 
			moves = Move.get_library_list(parm,current_user,'')
			render partial: "common_templates/admin/trash_content_table", locals: {moves: move}
		end
	end

end