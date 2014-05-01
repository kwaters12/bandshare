class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  has_attached_file :asset, :styles => { :medium => "300x300>", :thumb => "100x100>", :large => "600x600>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/

  def to_s
    caption? ? caption : "Picture"
  end
end
