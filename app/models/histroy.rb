class Histroy < ActiveRecord::Base
	belongs_to :move
	belongs_to :workout
end
