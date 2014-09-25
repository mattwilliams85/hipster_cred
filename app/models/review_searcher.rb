require 'open-uri'
require 'json'
require 'cgi'

class ReviewSearcher
  attr_accessor :album_name

  def initialize(album_name)
    @album_name = album_name
  end

  def search
    if validate
      Review.new.tap do |review|
        review.rating = html_text(:rating)
      end
    else
      Review.new.tap do |review|
        review.rating = false
      end
    end
  end

  def validate
    webpage = JSON.parse(open("http://pitchfork.com/search/ac/?query=#{CGI.escape(album_name)}").read).select {|object| object['label'] === 'Reviews'}.first
    if webpage["objects"].length == 0
      false
    else
      true
    end
  end

  def html_text(attribute)
    html_page.css(css_selector(attribute)).text
  end

  def css_selector(attribute)
    css_mappings[attribute]
  end

  def css_mappings
    { artist: "#{review_class} h1 a", album: "#{review_class} h2", rating: "#{review_class} .score", editorial: ".editorial" }
  end

  def review_class
    '.review-meta .info'
  end

  def html_page
    Nokogiri::HTML(open(review_url))
  end

  def review_url
    "http://pitchfork.com#{reviews.first['url']}"
  end

  def reviews
    object = search_result['objects']
    if object == []

    else
      object
    end
  end

  def search_result
    JSON.parse(open("http://pitchfork.com/search/ac/?query=#{CGI.escape(album_name)}").read).select {|object| object['label'] === 'Reviews'}.first
  end


end

class Review
  attr_accessor :rating, :artist, :album, :editorial
end
