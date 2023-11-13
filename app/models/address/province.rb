class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :region
  has_many :cities
  has_many :addresses

  def self.table_name_prefix
    "address_"
  end
end
