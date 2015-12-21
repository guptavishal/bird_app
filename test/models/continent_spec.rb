require "rails_helper"

describe "Bird", :type => :model do

  context 'mandatory fields are' do

    it 'name should be present' do
      expect{Continent.create!()}.to raise_error(Mongoid::Errors::Validations)
    end

  end

end
