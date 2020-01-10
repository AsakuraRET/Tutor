class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  before_action :check_if_tutor_has_payment_info!, only: :new
  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
  end

  def accept
    @offer = Offer.find(params[:id])
    respond_to do |format|
      if current_user.student?
        if @offer.state == "pending"
          @offer.update(state: 1)
          @offer.help_request.update(state: 1, tutor_id: @offer.tutor_id)
          @offer.help_request.offers.where(state: 0).update_all(state: 2)
          @chat = chat_for_redirect
          format.js
          format.html { redirect_to @chat }
        else
          format.js {render inline: "location.reload();" }
          format.html { redirect_to @offer.help_request }
        end
      else
        format.js {render inline: "location.reload();" }
        format.html { redirect_to root_path }
      end
    end
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    @help_request = HelpRequest.find(params[:help_request_id])
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params.merge(state: 0))

    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer.help_request, notice: 'Offer was successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url, notice: 'Offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_if_tutor_has_payment_info!
      redirect_to payment_registration_path unless current_user.stripe_id.present?
    end

    def chat_for_redirect
      Chat.where(chat_params).first || Chat.create(chat_params)
    end

    def chat_params
      {
        student_id: current_user.id,
        tutor_id: @offer.tutor_id
      }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit(:new_price, :help_request_id, :tutor_id)
    end
end
