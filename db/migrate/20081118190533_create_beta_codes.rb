class CreateBetaCodes < ActiveRecord::Migration
  def self.up
    create_table :beta_codes do |t|
      t.string :code
      t.integer :times_used
      t.integer :limit

      t.timestamps
    end
  end

  def self.down
    drop_table :beta_codes
  end
end
