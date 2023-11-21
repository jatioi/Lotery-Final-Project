class Client::LotteryController < ApplicationController
  before_action :skip_authentication, only: [:lottery]

  def index
    @categories = Category.all

    if params[:commit] == 'all' || !params[:commit].present?
      @items = Item.includes(:categories)
    else
      @items = Item.includes(:categories).where(categories: { name: params[:commit]})
    end
    @items = @items.starting.active
                   .where("start_at <= ?", Time.current)
                   .where("online_at <= ?", Time.current)
                   .where("offline_at > ?", Time.current)


  end
end
