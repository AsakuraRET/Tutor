class Admin::UsersController < ApplicationController
  before_action :user_admin

  layout "admin"

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
      format.xls { send_data @users.to_csv(col_sep: "\t") }
    end
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
  end

  private

  def user_admin
    redirect_to root_path unless current_user.admin?
  end
end
