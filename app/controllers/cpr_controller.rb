class CprController < ApplicationController
  def signup
    @sessions = Session.find(:all).sort {|a,b| a.name <=> b.name}
    session_options = @sessions.map{|s| "<option value=\"#{s.id}\">#{s.description}</option>"}
    @session_options_string = session_options.join "\n"

    @people = Person.find(:all).sort {|a,b| a.name <=> b.name}
    people_options = @people.map {|p| "<option value=\"#{p.id}\">#{p.name}</option>"}
    @people_options_string = people_options.join "\n"
  end

  def record_assignment
    @person = Person.find(params[:person_id])
    @assignment_was = @person.session_id
    @person.update_attribute("session_id", params[:session_id])
  end

end
