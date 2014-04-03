class Band < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  acts_as_taggable

end
