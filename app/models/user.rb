class User < ActiveRecord::Base
  validates :username, :presence => :true

  def find_top_ten
    @topalbums = []
    albums = LastFM::User.get_top_albums(:user => self.username)
    albums["topalbums"]["album"].each_with_index do |album, i|
      album = {"name" => album["name"], "artist" => album["artist"]["name"]}
      if find_stats(album)
        @topalbums << album
      end
      break if @topalbums.length == 5 || i == 49
    end
    @topalbums
  end


  def find_stats(album)
    @album = LastFM::Album.get_info(:artist => album["artist"], :album => album["name"])["album"]
    if rating(@album)
      album["rating"] = rating(@album)
      if unpopularity(@album)
        album["unpopularity"] = unpopularity(@album)
        album["freshness"] = freshness(@album)
        album["img_url"] = @album["image"][2]["#text"]
      else
      false
      end
    end
  end

  def rating(album)
    review = ReviewSearcher.new(album["name"]).search.rating
    if review
      review.strip.to_f
    else
      false
    end
  end

 def unpopularity(album)
    unpopularity = Echowrap.artist_familiarity(:name => album['artist']).familiarity
    if unpopularity >= 0.01
      (10 - (unpopularity * 10)).round(1)
    else
      false
    end
  end

  def freshness(album)
    yearformed = Echowrap.artist_search(:name => album['artist'], :bucket => 'years_active')
    if yearformed != []
      if yearformed.length == 2
        if yearformed[1].years_active != []
          yearformed = yearformed[1].years_active.first.start.to_i
        else
          yearformed = yearformed.first.years_active.first.start.to_i
        end
      else
        yearformed = yearformed.first.years_active.first.start.to_i
      end
      if yearformed >= 1950
        (10 - ((2015 - yearformed.to_f)/5.4)).round(1)

      end
    else
      false
    end
  end

  def validate_rating(album)
    if album["rating"] == false
      false
    else
      true
    end
  end

  def validate_freshness(album)
    if album["freshness"] == false
      false
    else
      true
    end
  end

  def find_score(albums)
    total = 0
    obscurity = 0
    freshness = 0
    rating = 0
    count = albums.length
    albums.each do |album|
      total += (album["unpopularity"] + album["freshness"] + album["rating"])/3
      obscurity += album["unpopularity"]
      freshness += album["freshness"]
      rating += album["rating"]
    end
    {"total" => (total/count).round(1), "obscurity" => (obscurity/count).round(1), "freshness" => (freshness/count).round(1), "rating" => (rating/count).round(1) }
  end

  def find_message(score)
    case score["total"].to_f
      when 0..2
        return "a mainstream whore"
      when 2.01..3
        return  "a ryan seacrestian"
      when 3.01..4
          return "a top 40 junkie"
      when 4.01..5
        return "officially sheeple"
      when 5.01..6
        return "pretty average"
      when 6.01..7
        return "prime hipster"
      when 7.01..8
        return "hipster cultist"
      when 8.01..10
        return "pure filth hipster scum"
      else
        return "BROKEN"
      end
    end
end

