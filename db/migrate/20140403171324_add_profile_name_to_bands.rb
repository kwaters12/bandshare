class AddProfileNameToBands < ActiveRecord::Migration
  def change
    add_column :bands, :owner, :string
  end
end
