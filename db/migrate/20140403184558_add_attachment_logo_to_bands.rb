class AddAttachmentLogoToBands < ActiveRecord::Migration
  def self.up
    change_table :bands do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :bands, :logo
  end
end
