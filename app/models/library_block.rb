class LibraryBlock < ActiveRecord::Base
	has_one :library_detail
	belongs_to :block
	belongs_to :move
end
