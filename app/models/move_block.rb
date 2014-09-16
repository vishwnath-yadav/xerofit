class MoveBlock < ActiveRecord::Base
	has_one :move_detail
	belongs_to :block
	belongs_to :move
end
