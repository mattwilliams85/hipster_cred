class User < ActiveRecord::Base
  validates :username, :presence => :true

  def find_top_ten
    @topartists = []
    artists = LastFM::User.get_top_artists(:user => self.username)
    artists["topartists"]["artist"].each_with_index do |artist, i|
      @topartists << {"artist" => artist["name"]}
      break if i == 9
    end
    find_popularity(@topartists)
  end


  def find_popularity(artists)
    @artists = artists
    @artists.each_with_index do |artist, i|
      artist = LastFM::Artist.get_info(:artist => artist["artist"])["artist"]
      artists[i]["popularity"] = artist["stats"]["listeners"].to_i/100
      yearformed = Echowrap.artist_search(:name => artist['name'], :bucket => 'years_active').first.years_active.first.start
      artists[i]["oldness"] = 2014 - yearformed.to_i
    end
    @artists
  end

end


