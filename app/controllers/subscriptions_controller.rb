class SubscriptionsController < ApplicationController
	def new
		@subscription = Subscription.new
	end

	def create
	  @subscription = Subscription.new(subscription_params)
	  if @subscription.save_with_payment
	    redirect_to @subscription, :notice => "Thank you for subscribing!"
	  else
	    render :new
	  end
	end

	private
	  def subscription_params
	    params.require(:subscription).permit!
	  end
end
