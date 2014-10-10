class MarketplaceList < ActiveRecord::Base
	has_many :marketplace_moves
	has_many :moves, through: :marketplace_moves
	validates :email, uniqueness: true, presence: true
end
