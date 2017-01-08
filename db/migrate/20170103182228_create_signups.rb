class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |table|
      table.belongs_to :meetup, index: true
      table.belongs_to :user, index: true
      table.timestamps null: false
    end
  end
end
