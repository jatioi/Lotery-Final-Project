class Admin::WinnersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_winner, only: :update

  def index
    @states = Winner.aasm.states.map(&:name)
    @winners = Winner.all.includes(:user, :item, :ticket)
  end

  def update
    if params[:commit] && params[:commit] == 'Submit'
      if @winner.submit!
        flash[:notice] = 'Winning item submitted.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    elsif params[:commit] && params[:commit] == 'Pay'
      @winner.admin = current_admin_user
      if @winner.pay!
        flash[:notice] = 'Winning item paid.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    elsif params[:commit] && params[:commit] == 'Ship'
      if @winner.ship!
        flash[:notice] = 'Winning item shipped.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    elsif params[:commit] && params[:commit] == 'Deliver'
      if @winner.deliver!
        flash[:notice] = 'Winning item delivered.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    elsif params[:commit] && params[:commit] == 'Publish'
      if @winner.publish!
        flash[:notice] = 'Winning item published.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    elsif params[:commit] && params[:commit] == 'Remove Publish'
      if @winner.remove_publish!
        flash[:notice] = 'Winning item unpublished.'
        redirect_to admin_winners_path
      else
        flash[:alert] = @winner.errors.full_messages
        redirect_to admin_winners_path
      end
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end

