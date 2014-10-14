class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array = Move::CATEGORIES
		@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	end

	def Lists_move
		@sort_array = Move::CATEGORIES
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves.page(params[:page]).per(2)
	end

	def search_in_discover_data
		@moves = MarketplaceList.find_by_title(params[:name]).moves
		@discovered_moves = @moves.by_name(params[:title]).by_category(params[:category]).by_target(params[:target_muscle_group]).where(status: Move::STATUS[0]).order('moves.updated_at desc').page(params[:page]).per(2)
	end

	# def search_for_home
	# 	@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	# end

	def discover_details
		@move = Move.find(params[:id])
		# if @move.user.id != current_user.id
		# 	@move.views_count += 1
		# 	@move.save!
		# end
	end

	def discover_video_info
		if params[:video_id].present?
			if params[:move_id].present?
				last_video_info = VideoInfo.where(move_id: params[:move_id]).order("updated_at asc")[0]
				@video_info = VideoInfo.find(params[:video_id])
				if last_video_info.present?
					views_count = last_video_info.completed_video_views + 1
					video_info.update_attributes(completed_video_views: views_count, view_completed_time: DateTime.now)
				end
			end
		else
			if params[:move_id].present?
				last_video_info = VideoInfo.where(move_id: params[:move_id]).last
				if last_video_info.present?
					views_count = last_video_info.video_views + 1
					@video_info = VideoInfo.create(move_id: params[:move_id], video_views: views_count,view_start_time: DateTime.now)
				else
					views_count = 1
					@video_info = VideoInfo.create(move_id: params[:move_id], video_views: views_count,view_start_time: DateTime.now)
				end
			end
		end
	end
end
