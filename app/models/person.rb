class Person < ActiveRecord::Base
  belongs_to :session
  validates_presence_of :name

end
