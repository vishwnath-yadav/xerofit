class Workout < ActiveRecord::Base
	belongs_to :user
	has_many :blocks

	STATES = [:initiated, :completed]

	Workout::STATES.each do |state|
	    define_method "#{state}?" do
	      self.state.try(&:to_sym) == state
	    end
	end

	
end
