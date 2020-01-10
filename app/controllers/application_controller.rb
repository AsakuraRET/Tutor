class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :except => [:landing]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_if_request_from_stripe!, only: :stripe_success

  def landing; end

  def home; end

  def settings; end

  def stripe_success

    response = HTTParty.post(
      "https://connect.stripe.com/oauth/token",
      :query => {
        client_secret: ENV['stripe_api_key'],
        code: params[:code],
        grant_type: "authorization_code"
      }
    )

    if response.parsed_response['error']
      @stripe_login_successful = false
    else
      current_user.update(stripe_id: response.parsed_response['stripe_user_id'])
      @stripe_login_successful = true
    end
  end

  def current_request
    if current_user.student?
      @help_requests = current_user.help_requests
    else
      @help_requests = HelpRequest.where(state: 0)
    end
  end

  def account
    @user = User.find(params[:id])
    if current_user.tutor?
      @offers = current_user.offers
      @help_requests = current_user.help_requests
      begin
        Stripe.api_key = ENV['stripe_api_key']
        balance = Stripe::Balance.retrieve({
          stripe_account: current_user.stripe_id
        })
        @balance = balance.pending[0].amount.to_f.round(2) / 100
        @transactions = current_user.help_requests.where(state: 2).map { |help_request| transaction_params(help_request) }.reverse
      rescue Stripe::InvalidRequestError,
             Stripe::AuthenticationError,
             Stripe::CardError,
             Stripe::APIConnectionError,
             Stripe::StripeError,
             Stripe::RateLimitError => e
        @balance = 0
        @error_balance = e.message
      end
    end
  end

  private

  def transaction_params help_request
    {
      date: help_request.updated_at.strftime("%d %b, %Y"),
      first_name: User.find_by(id: help_request.student_id).first_name,
      last_name: User.find_by(id: help_request.student_id).last_name,
      description: "Pay for #{help_request.subject.name}",
      fee: help_request.price * 0.2,
      amount: help_request.price * 0.8,
      tips: help_request.tips
    }
  end

  def check_if_request_from_stripe!
    redirect_to root_path unless params[:code]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: %i[
        email
        first_name
        last_name
        user_name
        age
        major
        school
        address
        zip_code
        type
      ]
    )
  end
end
