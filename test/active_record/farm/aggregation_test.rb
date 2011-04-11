require 'farm_base_conn'
# This object must be created.
class SongInfo
  attr_reader :artist, :genre
  def initialize(artist,genre)
    @artist = artist
    @genre = genre
  end
end
class Song < ActiveRecord::Base
  composed_of :songinfo, :class_name=>'SongInfo',
    :mapping => [%w(artist artist),%w(genre genre)]  
end

class CreateTable < ActiveRecord::Migration
  def self.up
    create_table :songs, :force=>true do |t|
      t.column :name, :string, :limit=>30, :null => false
      t.column :artist, :string, :limit=>200
      t.column :genre, :string, :limit=>30
    end
    
    s1 = Song.find_or_create_by_name("Rush")
    # Can't use s1.songinfo.artist="Ferras", it will throw error.
    s1.artist = "Ferras"
    s1.genre = "pop"
    s1.save 
  end
end

CreateTable.up

s1 = Song.find_by_name("Rush")
p s1
p s1.songinfo
p "ok"

