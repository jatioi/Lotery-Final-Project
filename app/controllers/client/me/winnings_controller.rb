class Client::Me::WinningsController < ApplicationController
  before_action :authenticate_client_user!
  def index
    @winnings = current_client_user.winning_items
  end
end