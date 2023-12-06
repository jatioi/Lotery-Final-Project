class Client::Me::OrdersController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_order, only: :update

  def index
    @orders = current_client_user.orders
  end
  def update
    if params[:commit] && params[:commit] == 'Cancel'
      if @order.cancel!
        flash[:notice] = 'Order Cancelled'
        redirect_to order_history_index_path
      else
        flash[:notice] = 'Order Cancel failed'
        redirect_to order_history_index_path

      end
    end
  end
  private
  def set_order
    @order = Order.find(params[:id])
  end
end
