class PaymentSourcesController < ApplicationController
  before_action :set_payment_source, only: [:show, :edit, :update, :destroy]
  before_action :check_if_student!, only: [:destroy, :edit, :update, :create, :new]

  # GET /payment_sources
  # GET /payment_sources.json
  def index
    @payment_sources = PaymentSource.all
  end

  # GET /payment_sources/1
  # GET /payment_sources/1.json
  def show
  end

  # GET /payment_sources/new
  def new
    @payment_source = PaymentSource.new
  end

  # GET /payment_sources/1/edit
  def edit
  end

  # POST /payment_sources
  # POST /payment_sources.json
  def create
    create_card = Payment::AttachCardToUser.call(params[:token], current_user)

    if params[:help_request_id].present?

      card = create_card[:card].id
      customer = create_card[:card].customer
      help_request = HelpRequest.find(params[:help_request_id])
      amount = (help_request.help_request_price_or_offer_price.round.to_i) * 100
      app_fee = amount * 2 / 10
      description = "Pay for #{help_request.subject.name}"
      destination = User.where(id: help_request.tutor_id).first&.stripe_id

      charge_message = Payment::MakeCharge.call(
        card,
        customer,
        amount,
        app_fee,
        destination,
        description
      )

      if charge_message[:success]
        help_request.update(state: 2) if help_request.state == "in_progress"
      else
        @unsuccess_message = charge_message[:message]
      end
    end

    if create_card[:success]
      render json: {
        message: 'OK'
      }, status: 200
    else
      render json: {
        error: create_card[:card]
      }, status: 422
    end
  end
  # PATCH/PUT /payment_sources/1
  # PATCH/PUT /payment_sources/1.json
  def update
    respond_to do |format|
      if @payment_source.update(payment_source_params)
        format.html { redirect_to @payment_source, notice: 'Payment source was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_source }
      else
        format.html { render :edit }
        format.json { render json: @payment_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_sources/1
  # DELETE /payment_sources/1.json
  def destroy
    @payment_source = current_user.payment_sources.find(params[:id])
    respond_to do |format|
      begin
        Stripe.api_key = ENV['stripe_api_key']
        Stripe::Customer.delete_source(
          current_user.stripe_id,
          @payment_source.stripe_id
        )
        @payment_source.destroy
        format.js { render :deleted }
        format.html { redirect_to account_path(id: current_user.id)}
      rescue Stripe::InvalidRequestError,
             Stripe::AuthenticationError,
             Stripe::CardError,
             Stripe::APIConnectionError,
             Stripe::StripeError,
             Stripe::RateLimitError => e
        @error_destroy = e.message
        format.js { render :deleted }
        format.html { redirect_to account_path(id: current_user.id)}
      end
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

    def check_if_student!
      redirect_to root_path unless current_user.student?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_payment_source
      @payment_source = PaymentSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_source_params
      params.require(:payment_source).permit(:last_4, :cvc, :exp_year, :exp_month, :student_id)
    end
end
