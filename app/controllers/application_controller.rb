class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_admin_mode

  def authenticate_active_admin_user!
  	authenticate_user!
  	unless current_user.admin?
  		flash[:alert] = "Unauthorized Access!"
  		redirect_to root_path
  	end
  end

  def after_sign_in_path_for(resource)
    root_url
  end

  def after_sign_out_path_for(resource)
    root_url
  end

  protected

  def check_admin_mode
  	if current_user
  		if ENV['ADMIN_MODE'] == 'true' && controller_name != 'sessions' && !current_user.admin?
  			render 'maintenance/index', :layout => 'maintenance'
  		end
  	else
  		if ENV['ADMIN_MODE'] == 'true' && controller_name != 'sessions'
  			render 'maintenance/index', :layout => 'maintenance'
  		end
  	end
  end
end
