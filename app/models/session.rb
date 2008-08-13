class Session < ActiveRecord::Base

  has_many :people

  def description
    remain = max_attendees - people.size()
    return "#{name} (#{remain} spots left)"
  end
end
