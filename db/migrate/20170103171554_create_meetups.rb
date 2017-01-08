class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |table|
      table.integer :creator_id, null: false
      table.string :name, null: false
      table.string :description, null: false
      table.string :location, null: false
    end
  end
end
