class ApplicationController < ActionController::Base
	def authorized
		redirect_to '/admin/' unless logged_in?
	end
	def logged_in?
		!current_user.nil?
	end
	def current_user
    	@current_user ||= Admin.find_by(username: session[:username])
    end
    def authorize
    	if logged_in?
    		return
    	else
    		redirect_to '/' unless logged_in2?
    	end
	end
	def logged_in2?
		!current_user2.nil?
	end
	def current_user2
		@current_user2 ||= User.find_by(id: session[:user_id])
	end	
end