class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :description
      t.integer :imageable_id
      t.string :imageable_type
      t.string :type

      t.timestamps
    end
  end
end
