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
		# parm = params.merge({type: Move::TYPE[0]}) 
		# @moves = Move.get_library_list(parm,current_user,'')
		@moves = FullWorkout.where(mark_complete: false, enable: true).order('updated_at desc')
	end

	def approval_page
		@sort_array = Move::ADMIN_APPROVE_FILTER
		parm = params.merge({status: Move::STATUS[2], sorted_by: "date_submitted_for_approval", order: "ASC"}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def move_filter
		@moves = Move.get_library_list(params,current_user,'')
	end

	def mark_complete
		move = FullWorkout.find(params[:id])
		move.mark_complete = params[:mark_as] == 'true' ? true : false
		move.save
		render nothing: true
	end

	def status_approve
		hist = Histroy.new()
		if params[:type] == Move::TYPE[0]
			move = Move.find_by_id(params[:id])
			hist.move_id = move.id
		else
			move = Workout.find_by_id(params[:id])
			hist.workout_id = move.id
		end
		hist.status = params[:status]
		move.status = params[:status]
		if move.status == Move::STATUS[2]
			move.date_submitted_for_approval = move.updated_at
		end
		hist.save
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
		fullworkout = FullWorkout.find(params[:id])
		redirect_to fullworkout.download_url
		# render nothing: true
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
		elsif params[:type] == Move::TYPE[1]
			@move = Workout.find(params[:id])
		else
			@move = FullWorkout.find(params[:id])
		end
		@move.enable = false
		@move.save
		redirect_to :back
	end

	def restore
		if params[:data_param] == "user"
			@sort_array = User::USER_TYPE
			user = User.find(params[:id])
			user.enabled = true
			user.save
			@users = User.where(enabled: false).order('updated_at desc')
			render partial: "admin/users/user_trash_content_table"
		elsif params[:data_param] == "full-workout"
			@sort_array = Move::ADMIN_UNCUT_TRASH_FILTER
			fullworkout = FullWorkout.find(params[:id])
			fullworkout.enable = true
			fullworkout.save
			@moves = FullWorkout.where(enable: false).order('updated_at desc')
			render partial: "admin/moves/uncut_workout_trash_table"
		else
			@sort_array = Move::ADMIN_TRASH_FILTER
			if params[:type] == Move::TYPE[0]
				@move = Move.find_by_id(params[:id])
			else
				@move = Workout.find_by_id(params[:id])
			end
			@move.enable = true
			@move.save
			parm = params.merge({enable: true,type: ''}) 
			@moves = Move.get_library_list(parm,current_user,'')
			render partial: "admin/moves/trash_list"
		end
		
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
			@sort_array = User::USER_TYPE
			@users = User.where(enabled: false).order('updated_at desc')
			render partial: "admin/users/user_trash_content_table"
		elsif params[:text] == "Uncut Workout Trash"
			@sort_array = Move::ADMIN_UNCUT_TRASH_FILTER
			@moves = FullWorkout.where(enable: false).order('updated_at desc')
			render partial: "admin/moves/uncut_workout_trash_table"
		else
			@sort_array = Move::ADMIN_TRASH_FILTER
			parm = params.merge({enable: true}) 
			@moves = Move.get_library_list(parm,current_user,'')
			render partial: "admin/moves/trash_list"
		end
	end

	def destroy_fullworkout
		full_workout = FullWorkout.find(params[:id])
		full_workout.destroy
		redirect_to :back
	end

	def uncut_filter
		@moves = FullWorkout.get_workout_list(params,current_user)
	end

	def approve_filter
		parm = params.merge({status: Move::STATUS[2], sorted_by: "date_submitted_for_approval"}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def trash_filter
		parm = params.merge({enable: true}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def histroy_page
		if params[:type] == Move::TYPE[1]
			@move = Workout.find(params[:id])
		else
			@move = Move.find(params[:id])
		end
		@histroy = @move.histroys
	end

	def uncut_trash_filter
		@sort_array = Move::ADMIN_UNCUT_TRASH_FILTER
		parm = params.merge({enable: true})
		@moves = FullWorkout.get_workout_list(parm,current_user)
	end
	
end