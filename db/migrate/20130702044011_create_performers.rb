class CreatePerformers < ActiveRecord::Migration
  def change
    create_table :performers do |t|
      t.string :type
      t.string :name, :nil => false, :default => ""
      t.string :aka, :nil => false, :default => ""
      t.text :profiles
      t.text :description

      t.timestamps
    end
  end
end
