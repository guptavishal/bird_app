class Continent
  include Mongoid::Document
  include Mongoid::Paranoia
  field :name, type: String
  embedded_in :bird

  validates_presence_of :name

end
