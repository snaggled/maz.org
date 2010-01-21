class AddCheckins < ActiveRecord::Migration
  def self.up
    create_table :fs_checkins do |t|
      t.integer :fs_id, :null => false, :unique => true
      t.integer :fs_venue_id
      t.string :shout
      t.datetime :checked_in_at
      t.timestamps
    end
    add_index :fs_checkins, :fs_id
    add_index :fs_checkins, :checked_in_at
    add_index :fs_checkins, [:fs_venue_id, :checked_in_at]

    create_table :fs_venues do |t|
      t.integer :fs_id, :null => false, :unique => true
      t.string :name, :address, :crossstreet, :city, :state, :zip, :phone
      t.decimal :geolat, :geolong, :precision => 15, :scale => 10
      t.timestamps
    end
    add_index :fs_venues, :fs_id
    add_index :fs_venues, :name
  end

  def self.down
    drop_table :fs_checkins
    drop_table :fs_venues
  end
end
