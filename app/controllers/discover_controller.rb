class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array =  Category.where(status: true).map(&:name)
		@list_move_hash = {}
		marketplaceList = MarketplaceList.where(status: true).order('list_order asc')
		moves = Move.where(status: Move::STATUS[0]).by_name(params[:title]).by_category(params[:category]).pluck(:id)
		marketplaceList.each do |list|
			@list_move_hash["#{list.title}"] = list.moves.select{|move| moves.include? move.id}
		end
		respond_to do |format|
			format.html
			format.js
		end
	end

	def Lists_move
		@sort_array = Category.where(status: true).map(&:name)
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves.page(params[:page]).per(25)
	end

	def search_in_discover_data
		@moves = MarketplaceList.find_by(title: params[:name]).moves
		@discovered_moves = @moves.by_name(params[:title]).by_category(params[:category]).by_target(params[:target_muscle_group]).where(status: Move::STATUS[0]).order('moves.updated_at desc').page(params[:page]).per(25)
	end

	def discover_details
		@move = Move.find(params[:id])
		previous_request = request.referer || discover_path
        title = ''
		if previous_request.split("/").length >= 5
			title = "#{CGI.unescape(previous_request.split("/").last)}"
		else 
			title = "Discover Home"
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
