class UsersController < ApplicationController

require 'wikipedia'


  def index
    @user = User.new
  end

  def create
    @topartists = LastFM::User.get_top_artists(:user => params[:user][:username])
    if @topartists
    @user = User.new(:username => params[:user][:username])
      if @user.save
        redirect_to user_path(@user)
    else
      flash[:alert] = "username field cannot be empty"
      render "index"
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @artists = @user.find_top_ten
  end

end

