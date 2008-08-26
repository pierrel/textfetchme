class AddPlansToPlan < ActiveRecord::Migration
  def self.up
    Plan.new(:number_of_triggers => 1, :price => 0.00).save
    Plan.new(:number_of_triggers => 5, :price => 5.00).save
    Plan.new(:number_of_triggers => 10, :price => 8.00).save
  end

  def self.down
    Plan.delete_all
  end
end
