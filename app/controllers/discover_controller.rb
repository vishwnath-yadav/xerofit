class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array = Move::CATEGORIES
		@marketplaceList = MarketplaceList.where(status: true)
	end

	def Lists_move
		@sort_array = Move::CATEGORIES
		binding.pry
		# @marketplaceList = MarketplaceList.find_by_title(params[:name]).moves
		@discovered_moves = MarketplaceList.find_by_title(params[:name]).moves
	end

	def search_in_discover_data
		@discovered_moves = Move.by_name(params[:title]).by_category(params[:category]).where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def discover_details
		@move = Move.find(params[:id])
	end
end
