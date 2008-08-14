class Person < ActiveRecord::Base
  belongs_to :session
  validates_presence_of :name

  # Why is this not found in cpr_controller.rb?  (Need to reload the server?)
  def all_not_reserved(session_ids)
    people = Person.find(:all).select {|p| not session_ids.member? p.session_id}
    people.sort {|a,b| a.name <=> b.name}
  end
end
