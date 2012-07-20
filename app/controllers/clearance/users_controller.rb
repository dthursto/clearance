class Clearance::UsersController < ApplicationController
  unloadable

  skip_before_filter :authorize,   :only => [:new, :create]
  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?

  def new
    @user = user_from_params
    render :template => 'users/new'
  end

  def create
    @user = user_from_params
    if @user.save
      sign_in(@user)
      redirect_back_or(url_after_create)
    else
      render :template => 'users/new'
    end
  end

  private

  def url_after_create
    '/'
  end

  def user_from_params
    user_params = params[:user] || Hash.new
    email, password = user_params.delete(:email), user_params.delete(:password)
    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end
end
