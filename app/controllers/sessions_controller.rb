class SessionsController < ApplicationController
  def new
    redirect_to LastFM.auth_url
  end

  def create
    token = params[:token]
    redirect_to root_path and return if !token || token == ""

    api_session = LastFM::Auth.get_session(:token => token, :api_sig => true)
    api_session = api_session["session"]

    user = User.find_by_username(api_session["name"])
    unless user
      # new user
      user = User.create(:username => api_session["name"])
    end

    session[:user_id]     = user.id
    session[:session_key] = api_session["key"]

    redirect_to root_path
  end
end
