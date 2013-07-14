class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.integer :payment_type
      t.text :payment_details
      t.boolean :info_confirmed
      t.boolean :agreement_confirmed
      t.integer :payable_id
      t.string :payable_type

      t.timestamps
    end
  end
end
