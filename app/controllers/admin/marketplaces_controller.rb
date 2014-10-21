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
		@moves = Move.joins(:marketplace_moves).where('marketplace_moves.marketplace_list_id = ?', params[:id]).by_exempt("false").order('marketplace_moves.moves_order asc')
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
		@moves_list = Move.by_exempt("abc").includes(:marketplace_lists).where(status: Move::STATUS[0]).order('updated_at desc')
	end

	def category_list
		@active_list = Category.where(status: true)
		@inactive_list = Category.where(status: false)
	end

	def update_list_moves_order
		if params[:order].present?
			MarketplaceMove.update(params[:order].keys, params[:order].values)
		end
		redirect_to :back
	end

	def new_category
		if params[:id].present?
			@category = Category.find(params[:id])
		else
			@category = Category.new
		end
	end

	def create_new_category
		@category = Category.new(category_params)
		if @category.save
			redirect_to category_list_admin_marketplaces_path, notice: "Category created successfully"
		else
			redirect_to :back, notice: "Category not Created"
		end
	end

	def update_category
		@category = Category.find(params[:id])
		if @category.present? 
			@category.update(category_params)			
			redirect_to category_list_admin_marketplaces_path, notice: "Category updated successfully"
		else
			redirect_to :back, notice: "Category not Updated"
		end
	end

	def exempt_users
		@users = User.where(is_exempt: 'true')
	end

	def add_user_in_exempt_list
		@users = User.all
	end

	def add_exempt_user
		User.update(params[:user].keys, params[:user].values)
		redirect_to admin_marketplaces_path
	end

	def remove_user_in_exempt_list
		user = User.find(params[:id])
		user.is_exempt = false
		user.save
		redirect_to :back, notice: "User Remove from Exempt list successfully."
	end

	def update_categories_list
		if params[:list_type].present?
			if params[:list_type] == 'active'
				Category.update(params[:active_list].keys, params[:active_list].values)
			else
				Category.update(params[:inactive_list].keys, params[:inactive_list].values)
			end
		end
		redirect_to category_list_admin_marketplaces_path
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

	def category_params
		params.require(:category).permit!
	end
end
