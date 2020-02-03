class AdminController < ApplicationController
  before_action :authorized, except: [:signin, :signup]

  attr_reader :current_admin

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** User can signin and the parameters would be validated!      
=end

  def signin
    if request.get?

    else
      admin = Admin.sign_in(params)
      
      if admin.nil?
        flash[:error] = "Username is Incorrect!"
        redirect_to admin_signin_path

      elsif admin
        Rails.cache.write(current_admin, params[:username])

        session[:username] = params[:username]
        session[:authenticate_admin] = true
        session[:expires_at_admin] = Time.current + 20.minutes

        flash[:success] = "You have been logged in."
        redirect_to admin_index_path

      else
        flash[:error] = "Password is Incorrect!"
        redirect_to admin_signin_path
      end

    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** New User would be created and Throwing Error if there is any errors     
=end

  def signup
    if request.get?

    else
      admin = Admin.sign_up(params)
      
      if admin
        Rails.cache.write(current_admin, params[:username])
        flash[:success] = "Account Created and Logged In"

        session[:username] = params[:username]
        session[:authenticate_admin] = true
        session[:expires_at_admin] = Time.current + 20.minutes

        redirect_to admin_index_path

      else
        flash[:error] = "Error in Details"
        redirect_to admin_signup_path
      end

    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Signning Out and Clearing the session      
=end

  def signout
    Rails.cache.write(current_admin, nil)
    
    session[:username] = nil
    session[:authenticate_admin] = false
    session[:expires_at_admin] = Time.current + 20.minutes

    flash[:success] = "You have successfully logged out!"
    redirect_to admin_signin_path
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Elastic Search Result would be printed from here!     
=end
  def search_result
    @adminObj = User.search_record(params)
    if !@adminObj.first
      flash[:Error] = "Either Query is empty or Record Not Found!"
      redirect_to admin_search_path
    end
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Report would be generated asynchronously in report.txt file    
=end

  def report
    ReportGeneratorWorker.perform_async
    flash[:success] = "Report is generated Asynchronously! Kindly see report.txt in the directory!"
    redirect_to admin_index_path
  end

=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Showing Admin Information and All the operations, one can perform!    
=end
  def index
    @admin = Rails.cache.read(current_admin)
  end

end
