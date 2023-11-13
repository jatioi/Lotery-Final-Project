class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :provinces
  has_many :addresses

  def self.table_name_prefix
    "address_"
  end
end
