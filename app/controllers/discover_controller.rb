class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array = Move::CATEGORIES
		@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	end

	def Lists_move
		@sort_array = Move::CATEGORIES
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves.page(params[:page]).per(25)
	end

	def search_in_discover_data
		@moves = MarketplaceList.find_by(title: params[:name]).moves
		@discovered_moves = @moves.by_name(params[:title]).by_category(params[:category]).by_target(params[:target_muscle_group]).where(status: Move::STATUS[0]).order('moves.updated_at desc').page(params[:page]).per(25)
	end

	def search_for_discover_home
		@moves = Move.by_category(params[:category]).where(status: Move::STATUS[0])
		# if @moves.present?
		# 	@moves.each 
		# 	@marketplaceList  =
		@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	end

	def discover_details
		@move = Move.find(params[:id])
	end

	def discover_video_info
		# binding.pry
		if params[:move_id].present?
			@move = Move.find_by_id(params[:move_id])
			if @move.user != current_user
				@video_info = VideoInfo.update_video_info(params[:video_id], @move, current_user)
			end
		end
	end
end
