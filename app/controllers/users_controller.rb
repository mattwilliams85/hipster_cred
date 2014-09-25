class UsersController < ApplicationController

  def index

    @user = User.new
  end

  def create
    @topalbums = LastFM::User.get_top_albums(:user => params[:user][:username])
    if @topalbums
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
    @albums = @user.find_top_ten
    @score = @user.find_score(@albums)
    @message = @user.find_message(@score)
  end

end

