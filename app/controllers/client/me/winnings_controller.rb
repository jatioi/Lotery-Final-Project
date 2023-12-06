class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_winning, only: [:claim, :update, :edit, :edit_share, :update_share]
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

  def edit_share; end

  def update_share
    @winning.picture = winning_params[:image]
    @winning.comment = winning_params[:comment]
    if @winning.save
      @winning.share! if @winning.may_share?
      flash[:notice] = 'Share successfully.'
      redirect_to winning_history_index_path
    else
      puts "Errors: #{@winner.errors.full_messages}"
      flash[:notice] = 'Share failed'
      render :claim
    end
  end

  def update
    @winning.address_id = winning_params[:address_id]
    if @winning.save
      @winning.claim! if @winning.may_claim?
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
    params.require(:winner).permit(:address_id, :image, :comment)
  end

end