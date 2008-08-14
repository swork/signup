class Session < ActiveRecord::Base

  has_many :people

  validates_presence_of :name
  validates_numericality_of :max_attendees

  def space_remaining
    max_attendees - people.size()
  end

  def description
    return "#{name} (#{space_remaining} spots left)"
  end

end
