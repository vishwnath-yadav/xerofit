class Admin::MarketplacesController < ApplicationController

	def index
		@active_list = MarketplaceList.where(status: true)
		@inactive_list = MarketplaceList.where(status: false)
	end

	def new
		@marketplace = MarketplaceList.new
	end

	def edit
		@marketplace = MarketplaceList.find(params[:id])
	end

	def create
		@marketplace = MarketplaceList.new(list_params)
		if @marketplace.save
		  redirect_to admin_marketplaces_path
		else
		  render action: 'new'
		end
	end

	def update_lists
		if params[:list_type].present?
			if params[:list_type] == 'active'
				MarketplaceList.update(params[:active_list].keys, params[:active_list].values)
			else
				MarketplaceList.update(params[:inactive_list].keys, params[:inactive_list].values)
			end
		end
		redirect_to admin_marketplaces_path
	end

	def moves_list
		@moves_list = Move.where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def fetch_active_list
		@move = Move.find_by_id(params[:id])
		@active_list = MarketplaceList.where(status: true)
	end

	def add_lists
		binding.pry
	end

	private

	def list_params
		params.require(:marketplace_list).permit!
	end
end
