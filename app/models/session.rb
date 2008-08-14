class Session < ActiveRecord::Base

  has_many :people

  validates_presence_of :name
  validates_numericality_of :max_attendees

  def description
    remain = max_attendees - people.size()
    return "#{name} (#{remain} spots left)"
  end
end
