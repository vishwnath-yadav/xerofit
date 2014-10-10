class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array = Move::CATEGORIES
		@marketplaceList = MarketplaceList.where(status: true)
	end

	def Lists_move
		@sort_array = Move::CATEGORIES
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves.page(params[:page]).per(25)
	end

	def search_in_discover_data
		@moves = MarketplaceList.find_by_title(params[:name]).moves
		@discovered_moves = @moves.by_name(params[:title]).by_category(params[:category]).where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def discover_details
		@move = Move.find(params[:id])
		if @move.user.id != current_user.id
			@move.views_count += 1
			@move.save!
		end
	end
end
