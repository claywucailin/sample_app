class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :ticket_id
      t.decimal :selling_price
      t.datetime :receipt_date

      t.timestamps
    end
  end
end
