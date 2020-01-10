module Payment

  class AttachCardToUser < ApplicationService

    attr_reader :card, :user

    def initialize(card, user)
      @card = card
      @user = user
    end

    def call
      begin
        Stripe.api_key = ENV['stripe_api_key']
        if user.stripe_id.present?
          payment_card = Stripe::Customer.create_source(
            user.stripe_id,
            {
              source: card,
            }
          )
          user.payment_sources.create(card_params(payment_card))
          {
            card: payment_card,
            success: true
          }
        else
          customer = Stripe::Customer.create({
            email: user.email,
            source: card
          })
          user.update(stripe_id: customer.id)
          user.payment_sources.create(card_params(customer.sources.data[0]))
          {
            customer: customer,
            success: true
          }
        end

      rescue Stripe::InvalidRequestError,
             Stripe::AuthenticationError,
             Stripe::CardError,
             Stripe::APIConnectionError,
             Stripe::StripeError,
             Stripe::RateLimitError => e
         {
           card: e.message,
           success: false
         }
      end
    end

    private
    def card_params card_or_source
      {
        stripe_id: card_or_source["id"],
        last_4:    card_or_source["last4"],
        cvc:       card_or_source["cvc_check"],
        exp_month: card_or_source["exp_month"],
        exp_year:  card_or_source["exp_year"]
      }
    end
  end
end
