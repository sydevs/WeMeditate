class CreateProgramVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :program_venues do |t|
      t.string :address
      t.string :room_information
      t.json :program_times
      t.integer :order 
      t.float :latitude
      t.float :longitude
      t.belongs_to :city, index: true

      t.timestamps
    end

    create_table :program_times do |t|
      t.integer :day_of_week
      t.time :start_time
      t.time :end_time
      t.belongs_to :program_venue, index: true
    end

    add_column :cities, :address, :string
  end
end
