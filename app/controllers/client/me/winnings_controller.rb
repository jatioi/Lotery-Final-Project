class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_winning, only: [:claim, :update, :edit]
  def index
    @winnings = current_client_user.winning_items
  end

  def claim
    @addresses = current_client_user.addresses
    @address = @winning.build_address
  end

  def edit
    @addresses = current_client_user.addresses
  end

  def update
    # render json: winning_params
    if @winning.update(winning_params)
      flash[:notice] = 'Prize claimed successfully.'
      redirect_to winning_history_index_path
    else
      puts "Errors: #{@winner.errors.full_messages}"
      flash[:notice] = 'Claimed unsuccessfully.'
      render :claim
    end
  end

  private
  def set_winning
    @winning = current_client_user.winning_items.find(params[:id])
  end

  def winning_params
    params.require(:winner).permit(:address_id)
  end

end