class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  before_action :require_logout, only: [:new, :create]
  def new 
    @user = User.new 
    render :new 
  end
  
  def create # <-- login 
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    
    if @user 
      login!(@user)
      redirect_to cats_url(@user)
    else
      flash.now[:errors] = ['Invalid Login']
      render :new 
    end
  end
  
  def destroy
    logout!
    redirect_to new_session_url
  end 

end