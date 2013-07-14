class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :venue_id
      t.text :description
      t.integer :category_id
      t.string :type

      t.timestamps
    end
  end
end
