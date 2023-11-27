class Client::ShopController < ApplicationController
  before_action :authenticate_client_user!, only: :create


  def index
    @offers = Offer.active
  end

  def show
    @order = Order.new
    @user = current_client_user
    @offer = Offer.find(params[:id])

  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

end
