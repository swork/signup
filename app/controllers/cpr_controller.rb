class CprController < ApplicationController
  def signup
    @sessions = Session.find(:all)
    @people = Person.find(:all)
  end

end
