class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :name
      t.text :description
      t.boolean :available
      t.float :price
      t.references :user, index: true
      t.references :document, index: true
      t.references :category, index: true
      t.references :subcategory, index: true
      
      t.timestamps
    end
  end
end
