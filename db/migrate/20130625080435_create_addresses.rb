class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string :addressable_type
      t.string :zipcode
      t.string :street_address
      t.integer :region_id
      t.string :recipient
      t.string :tel

      t.timestamps
    end
  end
end
