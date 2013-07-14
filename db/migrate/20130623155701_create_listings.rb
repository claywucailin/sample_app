class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :split_type
      t.integer :seller_id
      t.integer :status
      t.integer :tickets_count
      t.decimal :total_amount
      t.integer :event_id
      t.string :section
      t.string :row
      t.integer :seat_type
      t.integer :split_divisor
      t.integer :available_tickets_count
      t.decimal :list_price
      t.decimal :net_price
      t.decimal :commission
      t.decimal :sold_average_price
      t.decimal :unsold_average_price
      
      t.timestamps
    end
  end
end
