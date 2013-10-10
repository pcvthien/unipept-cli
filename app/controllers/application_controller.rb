class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_motd
  
  def set_motd
    file = Rails.root.join("public", "motd")
    @motd = File.read(file) if FileTest.exists?(file)
  end
  
  protected
  
  def authorize
    unless session[:admin]
      flash[:error] = "Please log in to use this feature"
      redirect_to root_url
    end 
  end
end
