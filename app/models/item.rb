class Item < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :batch_count, presence: true

  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }

  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  def destroy
    if item_category_ships.exists?
      errors.add(:base, "Cannot delete category with associated items")
      false
    else
      update(deleted_at: Time.current)
    end
  end
end