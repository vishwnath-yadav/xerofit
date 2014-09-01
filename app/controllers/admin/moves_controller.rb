class Admin::MovesController < ApplicationController
	def index
		@library = Move.where(is_full_workout: false).order('created_at desc')
	end 

	def edit
		@library = Move.find(params[:id])
		@disabled = ([@library.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = @library.is_full_workout ? 1024 : 250
		@size = @library.get_thumbnail()
		@count = @library.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @count!=5)
	end

	def uncut_workout
		@library = Move.where(is_full_workout: true).order('created_at desc')
	end

	def approval_page
		@moves = Move.where(is_full_workout: false).order('created_at desc')
		@moves << Workout.all.order('created_at desc')
		@moves = @moves.flatten
	end
end
