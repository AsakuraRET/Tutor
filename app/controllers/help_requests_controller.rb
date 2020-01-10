class HelpRequestsController < ApplicationController
  before_action :check_if_student!, only: [:destroy, :edit, :update, :create, :new, :finish_help_request, :charge, :tips]
  before_action :set_help_request, only: [:edit, :update, :destroy, :finish_help_request, :charge, :tips]
  before_action :check_if_student_has_payment_info!, only: [:destroy, :edit, :update, :create, :new, :charge, :tips]
  before_action :set_help_requests_collection, only: :search
  before_action :check_if_tutor_has_payment_info!, only: :accept

  # GET /help_requests
  # GET /help_requests.json
  def index
    @help_requests = current_user.help_requests.all
  end

  def search
    if params[:subject_id].present?
      @help_requests = @hr_collection.searched(params[:subject_id], params[:direction])
    else
      @help_requests = @hr_collection.ordered(params[:direction])
    end
    respond_to do |format|
      format.js {render}
    end
  end

  # GET /help_requests/1
  # GET /help_requests/1.json
  def show
    if current_user.tutor?
      @help_request = HelpRequest.find(params[:id])
    else
      @help_request = current_user.help_requests.find(params[:id])
      @offers = @help_request.offers
    end
  end

  def accept
    @help_request = HelpRequest.find(params[:id])
    if @help_request.state == "pending"
      @help_request.update(tutor_id: current_user.id, state: 1)
      @help_request.offers.update_all(state: 2)
      redirect_to chat_for_redirect
    else
      redirect_to @help_request
    end
  end

  def finish_help_request
    respond_to do |format|
      if @help_request.state == "in_progress"
        format.js {render :finished_help_request}
        format.html { redirect_to @help_request }
      else
        format.js {render inline: "location.reload();"}
      end
    end
  end

  def charge
    amount = (@help_request.help_request_price_or_offer_price.round.to_i) * 100
    app_fee = amount * 2 / 10
    description = "Pay for #{@help_request.subject.name}"
    destination = User.find(@help_request.tutor_id).stripe_id

    charge_message = Payment::MakeCharge.call(
      params[:stripe_id],
      params[:customer],
      amount,
      app_fee,
      destination,
      description
    )
    if charge_message[:success]
      @help_request.update(state: 2) if @help_request.state == "in_progress"
      @success_message = charge_message[:message]
    else
      @unsuccess_message = charge_message[:message]
    end
    respond_to do |format|
      format.js
    end
  end

  def tips

    amount = params[:tips].to_i * 100
    description = "Tips for #{@help_request.subject.name}"
    destination = User.find(@help_request.tutor_id).stripe_id
    app_fee = 0

    tips = Payment::MakeCharge.call(
      params[:stripe_id],
      params[:customer],
      amount,
      app_fee,
      destination,
      description
    )

    if tips[:success]
      @help_request.update(tips: params[:tips]) if @help_request.state == "finished"
      @success_message = tips[:message]
    else
      @unsuccess_message = tips[:message]
    end
    respond_to do |format|
      format.js {render :charge}
    end
  end

  # GET /help_requests/new
  def new
    @help_request = current_user.help_requests.new
  end

  # GET /help_requests/1/edit
  def edit
  end

  # POST /help_requests
  # POST /help_requests.json
  def create
    @help_request = current_user.help_requests.new(help_request_params)

    respond_to do |format|
      if @help_request.save
        format.html { redirect_to current_request_path, notice: 'Help request was successfully created.' }
        format.json { render :show, status: :created, location: @help_request }
      else
        format.html { render :new }
        format.json { render json: @help_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /help_requests/1
  # PATCH/PUT /help_requests/1.json
  def update
    respond_to do |format|
      if @help_request.update(help_request_params)
        format.html { redirect_to @help_request, notice: 'Help request was successfully updated.' }
        format.json { render :show, status: :ok, location: @help_request }
      else
        format.html { render :edit }
        format.json { render json: @help_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /help_requests/1
  # DELETE /help_requests/1.json
  def destroy
    @help_request.destroy
    respond_to do |format|
      format.html { redirect_to help_requests_url, notice: 'Help request was successfully destroyed.' }
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
        student_id: @help_request.student_id,
        tutor_id: current_user.id
      }
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_help_request
      @help_request = current_user.help_requests.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_request_params
      params.require(:help_request).permit(:description, :subject_id, :price, :problem_picture)
    end

    def check_if_student!
      redirect_to root_path unless current_user.student?
    end

    def check_if_student_has_payment_info!
      redirect_to new_payment_source_path unless current_user.stripe_id.present?
    end

    def set_help_requests_collection
      if current_user.tutor?
        @hr_collection = HelpRequest
      else
        @hr_collection = current_user.help_requests
      end
    end
end
