class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :event_id
      t.string :section
      t.string :row
      t.string :seat
      t.integer :listing_id
      t.decimal :list_price
      t.decimal :net_price
      t.decimal :commission
      t.integer :status
      t.integer :seller_id
      t.integer :buyer_id

      t.timestamps
    end
  end
end
