class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :buyer_id
      t.integer :shipment_method
      t.datetime :payment_date
      t.integer :payment_method
      t.decimal :total_amount
      t.datetime :shipment_date
      t.integer :status
      t.decimal :shipment_fee
      t.decimal :service_fee
      t.decimal :tickets_amount
      t.integer :seller_id

      t.timestamps
    end
  end
end
