class DatasetsController < ApplicationController

  def index
    @dataset = nil
    @test = LastFM::User.get_top_albums(:user => "syncr")
  end



end
