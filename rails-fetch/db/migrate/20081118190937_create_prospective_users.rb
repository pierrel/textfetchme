class CreateProspectiveUsers < ActiveRecord::Migration
  def self.up
    create_table :prospective_users do |t|
      t.string :email
      t.string :website
      t.string :heard_from

      t.timestamps
    end
  end

  def self.down
    drop_table :prospective_users
  end
end
