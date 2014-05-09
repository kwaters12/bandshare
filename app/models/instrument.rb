class Instrument < ActiveRecord::Base

  has_one :category
  has_one :subcategory

  belongs_to :user
  belongs_to :document

  accepts_nested_attributes_for :document
  
end
