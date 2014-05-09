class Category < ActiveRecord::Base
  belongs_to :instrument
  has_many :subcategories
end
