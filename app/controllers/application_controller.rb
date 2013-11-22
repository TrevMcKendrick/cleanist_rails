class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_user

  def confirm
  end

  def archive
    @user.archive
    redirect_to root_path, :notice => "successfully archived"
  end

  private
   
    def find_user
      if session[:user_id]
        @user = User.find(session[:user_id]) 
      else
        redirect_to root_path
      end
    end
end
