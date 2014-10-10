class MarketplaceMove < ActiveRecord::Base
	belongs_to :move
	belongs_to :marketplace_list
end
