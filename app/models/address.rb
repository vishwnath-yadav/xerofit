class Address < ActiveRecord::Base
	belongs_to :user
	ADDRESS_TYPE = ["Billing"]
end
