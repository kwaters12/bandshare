class Band < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  belongs_to :document
  belongs_to :user

  accepts_nested_attributes_for :document

  acts_as_taggable

end
