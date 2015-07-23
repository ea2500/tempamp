class Item < ActiveRecord::Base
  belongs_to :user
  validates :name, :price, :description, presence: true
end
