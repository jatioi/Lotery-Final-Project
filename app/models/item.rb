class Item < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :start_at, presence: true
  validates :offline_at, presence: true

  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }

  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships

  has_many :categories, through: :item_category_ships
  has_many :winners
  has_many :tickets
  has_many :winners

  def destroy
    if tickets.present?
      errors.add(:base, "Cannot delete item with associated tickets")
      false
    else
      update(deleted_at: Time.current)
    end
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], guard: :before_start, to: :starting, after: :after_start
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :exceeded_max_bets?, after: :set_winner
    end

    event :cancel do
      transitions from: :starting, to: :cancelled, after: [:revert_quantity, :cancel_all_tickets]
    end
  end

  private

  def set_winner
    winning_ticket = tickets.where(batch_count: batch_count).sample
    all_tickets = tickets.where(batch_count: batch_count).pending
    all_tickets.each do |ticket|
      if ticket == winning_ticket
        unless ticket.win!
          p ticket.errors.full_messages
        end
      else
        unless ticket.lose!
          p ticket.errors.full_messages
        end
      end
    end

    winner = winners.build do |w|
      w.ticket = winning_ticket
      w.user = winning_ticket.user
      w.item_batch_count = batch_count
    end
    unless winner.save
      p winner.errors.full_messages
    end
  end


  def exceeded_max_bets?
    pending_tickets_count = tickets.where(item: self, batch_count: batch_count, state: 'pending').count

    if pending_tickets_count >= minimum_tickets
      true
    else
      errors.add(:base, 'Have not reached minimum tickets.')
      false
    end
  end

  def current_bets_count
    tickets.count
  end

  def before_start
    unless quantity.to_i.positive? && Time.current < offline_at && status == 'active'
      return false
    end
    true
  end

  def after_start
    self.quantity -= 1
    self.batch_count += 1
    save!
  end



  def update_quantity_batch_count
    unless aasm.from_state == :paused
      update(quantity: quantity - 1, batch_count: batch_count + 1)
    end
  end

  def revert_quantity
    update(quantity: quantity + 1, batch_count: batch_count - 1)
  end

  def quantity_enough?
    self.quantity > 0
  end

  def present_day_less_than_offline_at?
    Time.current < self.offline_at
  end

  def is_item_active?
    self.active?
  end

  def offline_at_in_future?
    return true unless offline_at.present? && offline_at < Time.current
    errors.add(:offline_at, 'must be in the future')
    false
  end

  def online_at_before_offline_at?
    return true unless online_at.present? && online_at <= Time.current && offline_at < online_at
    errors.add(:online_at, 'must be before offline at date')
    false
  end

  def is_start_at_valid?
    return true if start_at.present? && start_at >= online_at && start_at < offline_at
    errors.add(:start_at, 'must be between online at and offline at')
    false
  end

  def cancel_all_tickets
    # Your implementation to cancel all tickets for this item
    tickets.update_all(state: 'canceled')

  end
end
