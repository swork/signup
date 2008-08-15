class CprController < ApplicationController

  def dispatch
    if @@management_magicwords.include? @magicword
      redirect_to :action => "manage"
    elsif @@user_magicwords.include? @magicword
      redirect_to :action => "signup"
    else
      redirect_to "/"
    end
  end

  def signup
    if not @@magicwords.include? @magicword
      redirect_to "/"
    end
 
    sall = Session.find(:all)
    sids = sall.map {|s| s.id}
    @people = Person.find(:all).select {|p| not sids.member? p.session_id}    

    @sessions = sall.select {|s| s.space_remaining > 0}

    if @sessions.empty? or @people.empty?
      render :action => "nomore"
    end

    @sessions = @sessions.sort {|a,b| a.name <=> b.name}
    session_options = @sessions.map{|s| "<option value=\"#{s.id}\">#{s.description}</option>"}
    @session_options_string = session_options.join "\n"

    @people = @people.sort {|a,b| a.name <=> b.name}
    people_options = @people.map {|p| "<option value=\"#{p.id}\">#{p.name}</option>"}
    @people_options_string = people_options.join "\n"
  end

  def manage
    if not @@management_magicwords.include? @magicword
      redirect_to "/"
    end
  end

  def list
    if not @@management_magicwords.include? @magicword
      redirect_to "/"
    end
    @sessions = Session.find(:all).sort {|a,b| a.name <=> b.name}
    @people = Person.find(:all).sort {|a,b| a.name <=> b.name}
    @now = Time.now.asctime
  end
end
