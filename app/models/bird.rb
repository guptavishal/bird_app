class Bird
  include Mongoid::Document
  include Mongoid::Paranoia
  field :name, type: String
  field :family, type: String
  field :added, type: String
  field :visible, type: Mongoid::Boolean
  embeds_many :continents

  before_validation :generate_default_values
  validates_presence_of :name, :family
  validate :continents_validation

  def generate_default_values
    if self.visible == nil
      self.visible=false
    end
    if self.added == nil
      self.added=Time.now.getutc.to_date.strftime('%Y-%m-%d')
    end
    true
  end

  def continents_validation
    if self.continents.blank?
      errors.add(:continents, "No continent found")
    end
  end

end
