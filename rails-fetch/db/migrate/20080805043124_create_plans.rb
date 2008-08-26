class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :number_of_triggers
      t.decimal :price

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
