class UsersController < ApplicationController

  def index
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:username] == ""
      flash[:alert] = "Username field cannot be empty"
      render "index"
    elsif @user.valid_account? && @user.save
      if Pandora::User.new(@user.username).recent_activity.first == nil
        flash[:alert] = "User has no bookmarked songs"
        render "index"
      else
      redirect_to user_path(@user)
      end
    else
      flash[:alert] = "No account found with that username"
      render "index"
    end
  end

  def show
    @user = User.find(params[:id])
    @albums = @user.find_top_ten
    if @albums == 'failed' || @albums == nil
      flash[:alert] = "Unfortunately you dont have enough data"
      redirect_to users_path
    else
    @score = @user.find_score(@albums)
    @message = @user.find_message(@score)
    end
  end

end

