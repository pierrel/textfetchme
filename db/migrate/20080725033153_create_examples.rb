class CreateExamples < ActiveRecord::Migration
  def self.up
    create_table :examples do |t|
      t.string :name
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :examples
  end
end
