class Item < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :start_at, presence: true
  validates :offline_at, presence: true


  mount_uploader :image, ImageUploader
  # enum status: { inactive: 0, active: 1 }

  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships

  has_many :categories, through: :item_category_ships
  has_many :winners

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], guard: :before_start, to: :starting, after: :after_start
      transitions from: :paused, to: :starting, after: :after_start
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  private

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

end
