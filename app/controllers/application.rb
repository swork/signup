# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  @@management_magicwords = ['victoria']
  @@user_magicwords = ['ropeline']
  @@magicwords = @@management_magicwords + @@user_magicwords

  helper :all # include all helpers, all the time

  before_filter :establish_magicword

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '169136c6c41f1fe5124a2e7785aa896e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # In lieu of full legitimate authentication, just keep a set of
  # obscure magicwords and determine access and initial dispatch on
  # this value.
  private
  def establish_magicword
    if not params[:magicword].nil?
      @magicword = params[:magicword]
      cookies[:magicword] = @magicword # remember for next request
    elsif not cookies[:magicword].nil?
      @magicword = cookies[:magicword]
    else
      @magicword = ''
    end
  end

end
