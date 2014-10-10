class DiscoverController < ApplicationController
	autocomplete :move, :title

	def home
		@sort_array = Move::CATEGORIES
		@discovered_moves = Move.where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def discover
		@sort_array = Move::CATEGORIES
		@discovered_moves = Move.where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def search_in_discover_data
		@discovered_moves = Move.by_name(params[:title]).by_category(params[:category]).where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def discover_details
		@move = Move.find(params[:id])
	end
end
