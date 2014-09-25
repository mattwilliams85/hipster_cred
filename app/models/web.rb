require 'rubygems'
require 'bundler'
Bundler.require

require 'sinatra'
require './review_searcher'

get '/style.css' do
  scss :style
end

get '/' do
  haml :index
end

post '/search' do
  @review = ReviewSearcher.new(params[:query]).search

  haml :search
end
