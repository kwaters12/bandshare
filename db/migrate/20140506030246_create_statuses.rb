class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :content
      t.references :user, index: true
      t.references :document, index: true

      t.timestamps
    end
  end
end
