class Client::LotteryController < ApplicationController
  before_action :authenticate_client_user!, only: :create
  before_action :set_item, only: [:show]

  def index
    @user = current_client_user
    @categories = Category.all
    @selected_category = params[:category_id] ? Category.find(params[:category_id]) : nil
    @items = @selected_category ? @selected_category.items : Item.includes(:categories).all

    if @selected_category
      @items = @selected_category.items.where(state: 'starting')
    else
      @items = Item.includes(:categories).where(state: 'starting')
    end
  end

  def show
    @ticket = Ticket.new
    @user = current_client_user
    @progress_percentage = (Ticket.where(batch_count: @item.batch_count).count.to_f / @item.minimum_tickets) * 100
  end

  def search
    @categories = Category.find_by(name: category_name)
    render client_lottery_index_path
  end

  def create
    quantity = params[:ticket][:quantity].to_i
    @item = Item.find(params[:ticket][:item_id])

    if quantity.positive? && current_client_user && current_client_user.coins.to_i >= quantity
      Ticket.transaction do
        # Create and save tickets
        quantity.times do
          ticket = current_client_user.tickets.new(item: @item)
        end

        # Update user's coins
        current_client_user.update(coins: current_client_user.coins - quantity)

        flash[:notice] = "You successfully bought #{quantity} ticket/s."
      end
    elsif quantity <= 0
      flash[:alert] = "Quantity must be a positive number."
    else
      flash[:alert] = "Not enough coins to create a ticket."
    end

    redirect_to lottery_path(@item)
  end




  private

  def set_item
    @item = Item.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(
      :user_id,
      :coins,
      :state
    )
  end
end