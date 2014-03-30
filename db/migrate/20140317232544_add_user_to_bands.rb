class AddUserToBands < ActiveRecord::Migration
  def change
    add_reference :bands, :user, index: true
  end
end
