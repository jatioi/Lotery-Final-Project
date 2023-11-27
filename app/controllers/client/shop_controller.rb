class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, only: :create
  before_action :set_offer, only: [:create]

  def index
    @offers = Offer.active
  end

  def show
    @order = Order.new
    @user = current_client_user
    @offer = Offer.find(params[:id])

  end

  def create
    @order = current_client_user.orders.build do |order|
      order.offer = @offer
      order.genre = 'deposit'
      order.amount = @offer.amount
      order.coin = @offer.coin
    end

    if @order.save
      flash[:notice] = 'Created order.'
      redirect_to shop_index_path
    else
      flash.now[:alert] = @order.errors.full_message
      render shop_path(@offer)
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:offer_id])
  end

end
