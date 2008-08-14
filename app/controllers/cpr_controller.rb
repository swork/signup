class CprController < ApplicationController
  def signup
    @sessions = Session.find(:all).sort {|a,b| a.name <=> b.name}
    session_options = @sessions.map{|s| "<option value=\"#{s.id}\">#{s.description}</option>"}
    @session_options_string = session_options.join "\n"
    sids = @sessions.map {|s| s.id}

    @people = Person.find(:all).select {|p| not sids.member? p.session_id}
    @people = @people.sort {|a,b| a.name <=> b.name}
    people_options = @people.map {|p| "<option value=\"#{p.id}\">#{p.name}</option>"}
    @people_options_string = people_options.join "\n"
  end

end
