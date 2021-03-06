class AlldoneController < ApplicationController
  before_filter :verify_ids

  def record
    if not @@magicwords.include? @magicword
      redirect_to "/"
    end
    @person = Person.find(params[:person_id])
    @assignment_was = @person.session_id
    @person.update_attribute("session_id", params[:session_id])
    @session = Session.find(params[:session_id])
    cookies[:magicword] = nil
  end

  private
  def verify_ids
    if params[:session_id].nil? or params[:person_id].nil?
      render :action => "tryagain"
    end
  end
end
