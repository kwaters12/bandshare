class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.text :genres
      t.text :links
      t.string :address

      t.timestamps
    end
  end
end
