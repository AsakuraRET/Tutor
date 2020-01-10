module Payment

  class MakeCharge < ApplicationService

    attr_reader :card, :customer, :amount, :app_fee, :destination, :description

    def initialize(card, customer, amount, app_fee, destination, description)
      @card = card
      @customer = customer
      @amount = amount
      @app_fee = app_fee
      @destination = destination
      @description = description
    end

    def call
      begin
        Stripe.api_key = ENV['stripe_api_key']
        charge = Stripe::Charge.create(charge_attributes)
        {
          message: charge.outcome.seller_message,
          success: true
        }
      rescue Stripe::InvalidRequestError,
             Stripe::AuthenticationError,
             Stripe::CardError,
             Stripe::APIConnectionError,
             Stripe::StripeError,
             Stripe::RateLimitError => e
         {
           message: e.message,
           success: false
         }
      end
    end

    private

      def charge_attributes
        {
          amount: amount,
          currency: "usd",
          source: card,
          customer: customer,
          application_fee_amount: app_fee,
          description: description,
          transfer_data: {
            destination: destination
          },
        }
      end

  end
end
