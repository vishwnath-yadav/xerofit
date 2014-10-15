class DiscoverController < ApplicationController
	autocomplete :move, :title
	# add_breadcrumb " Discover Home", :discover_path

	def home
		@sort_array = Move::CATEGORIES
		@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	end

	def Lists_move
		@sort_array = Move::CATEGORIES
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves.page(params[:page]).per(25)
		if @discovered_moves.present? 
			add_breadcrumb params[:name], "/discover/#{params[:name]}"
		end	
	end

	def search_in_discover_data
		@moves = MarketplaceList.find_by(title: params[:name]).moves
		@discovered_moves = @moves.by_name(params[:title]).by_category(params[:category]).by_target(params[:target_muscle_group]).where(status: Move::STATUS[0]).order('moves.updated_at desc').page(params[:page]).per(25)
	end

	def search_for_discover_home
		@moves = Move.by_category(params[:category]).where(status: Move::STATUS[0])
		@marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
	end

	def discover_details
		@move = Move.find(params[:id])
		previous_request = request.referer || discover_path		
        title = ''
		if previous_request.split("/").length >= 5
			title = "< #{CGI.unescape(previous_request.split("/").last)}"
		else 
			title = "< Discover Home"
		end	
		add_breadcrumb title, previous_request
	end

	def discover_video_info
		if params[:move_id].present?
			@move = Move.find_by_id(params[:move_id])
			if @move.user != current_user
				@video_info = VideoInfo.update_video_info(params[:video_id], @move, current_user)
			end
		end
	end
end
