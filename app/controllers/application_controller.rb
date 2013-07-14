class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_region
    # TODO need to fix according to user's region fetch from ip or selection
    session[:current_region] ||= (current_user.try(:address).try(:region).try(:id) || Region.first.id)
  end
  
  def current_region=(value)
    session[:current_region] = value
  end

end
