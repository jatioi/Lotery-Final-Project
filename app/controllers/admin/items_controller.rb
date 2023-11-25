class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:edit, :update, :show, :destroy, :start, :end, :pause, :cancel]

  def index
    @items = Item.all
  end
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'Item created successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Item creation failed.'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if params[:commit] == 'Start' && @item.start!
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    elsif params[:commit] == 'Pause' && @item.pause!
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    elsif params[:commit] == 'End' && @item.end!
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    elsif params[:commit] == 'Cancel' && @item.cancel!
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    elsif @item.update(item_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Item update failed.'
      render :edit, status: :unprocessable_entity
    end
  end


  def start

    if @item.may_start?
      @item.start!
      flash[:notice] = 'Item start successfully'
    else
      flash[:notice] = 'Item failed to start'
    end

    redirect_to admin_items_path
  end

  def show; end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Item paused successfully'
    else
      flash[:notice] = 'Item failed to pause'
    end
    redirect_to admin_items_path
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Item end successfully'
    else
      flash[:notice] = 'Item failed to end'
    end
    redirect_to admin_items_path
  end

  def cancel
    @item.cancel! if @item.may_cancel?
    redirect_to admin_items_path
  end
  def destroy
    @item.destroy
    flash[:notice] = 'Item destroyed successfully'
    redirect_to admin_items_path
  end




  private

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_tickets, :start_at, :online_at, :offline_at, :status, category_ids: [])
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
