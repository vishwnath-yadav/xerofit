class Subscription < ActiveRecord::Base
	attr_accessor :stripe_card_token

	def save_with_payment
	  if valid?
	  	logger.debug("vaid")
	    customer = Stripe::Customer.create(description: "This is xerofit test", card: stripe_card_token)
	    logger.debug(">>>>>>>>>>>>")
	    logger.debug(customer)
	    self.customer_id = customer.id
	    save!
	  end
	rescue Stripe::InvalidRequestError => e
	  logger.error "Stripe error while creating customer: #{e.message}"
	  errors.add :base, "There was a problem with your credit card."
	  false
	end
end
