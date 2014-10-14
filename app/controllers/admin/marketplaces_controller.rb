class Admin::MarketplacesController < ApplicationController

	def index
		@active_list = MarketplaceList.where(status: true).order('list_order asc')
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
		@moves_list = Move.includes(:marketplace_lists).where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def fetch_active_list
		@move = Move.find_by_id(params[:id])
		@active_marketplace_list = MarketplaceList.where(status: true)
		@inactive_marketplace_list = MarketplaceList.where(status: false)
		@marketplace_selected_list = MarketplaceMove.all.select{|l| l.move_id == @move.id}.collect{|d| d.marketplace_list_id}.compact
	end

	def add_lists
		move = Move.find_by_id(params[:move_id])
		marketplace_lists = params[:list_check][:list_ids]
		marketplace_selected_list = MarketplaceMove.all.select{|l| l.move_id == move.id}
		if marketplace_selected_list.size > 0
			marketplace_selected_list.each do |l|
				l.destroy
			end
		end
		marketplace_lists.each do |l|
			unless l.blank?
				MarketplaceMove.create(move_id: move.id, marketplace_list_id: l)
			end
		end
		redirect_to moves_list_admin_marketplaces_path
	end

	def delete_move_in_list
		if params[:market_id].present? && params[:move_id].present? 
			market_move = MarketplaceMove.where(move_id: params[:move_id], marketplace_list_id: params[:market_id]).first
			market_move.destroy
			redirect_to :back, notice: "Move Destroy from list successfully."
		end
	end

	def delete_list
		if params[:list_id].present?
			marketplace_moves = MarketplaceMove.where(marketplace_list_id: params[:list_id])
			if marketplace_moves.present?
				marketplace_moves.each do |market_move|
					market_move.destroy
				end
			end
			market_list = MarketplaceList.find(params[:list_id])
			market_list.destroy
			redirect_to admin_marketplaces_path, notice: "Move List Destroyed successfully."
		end
	end

	private

	def list_params
		params.require(:marketplace_list).permit!
	end
end
