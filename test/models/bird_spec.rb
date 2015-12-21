require "rails_helper"

describe "Bird", :type => :model do

  before(:all) do
    Bird.delete_all
    @bird1 = Bird.create!(:name=>"name-1", :family => "family-1", :continents => [Continent.new(:name=>"c1")])
    @today_date_utc = Time.now.getutc.to_date.strftime('%Y-%m-%d')
  end


  context 'default values for' do

    it 'visible should be false ' do
      expect(@bird1.visible).to eq(false)
    end

    it 'visible should be false if nil is explicity passed' do
      @bird2 =  Bird.create!(:name=>"name-2", :family=>"family-2", :visible => nil,:continents => [Continent.new(:name=>"c2")])
      expect(@bird2.visible).to eq(false)
    end

    it 'added should be todays UTC date' do
      expect(@bird1.added).to eq(@today_date_utc)
    end

    it 'added should be todays UTC date if nil is explicity passed' do
      today_date_utc = Time.now.getutc.to_date.strftime('%Y-%m-%d')
      @bird3 =  Bird.create!(:name=>"name-3", :family=>"family-3", :added => nil, :continents => [Continent.new(:name=>"c3")])
      expect(@bird3.added).to eq(today_date_utc)
    end

  end

  context 'mandatory fields are' do

    it 'name should be present' do
      expect{Bird.create!(:family=>"family-x",
                          :continents => [Continent.new(:name=>"c3")])}.to raise_error(Mongoid::Errors::Validations)
    end

    it 'family should be present' do
      expect{Bird.create!(:name=>"name-x",
                          :continents => [Continent.new(:name=>"c3")])}.to raise_error(Mongoid::Errors::Validations)
    end

    it 'continents should be present' do
      expect{Bird.create!(:name=>"name-x", :family=>"family-x")}.to raise_error(Mongoid::Errors::Validations)
    end

  end

  context 'deletion' do
    it 'should be a soft delete' do
      @bird1.delete
      expect{Bird.find(@bird1._id)}.to raise_error(Mongoid::Errors::DocumentNotFound)
      expect(Bird.deleted[0]._id).to eq(@bird1._id)
    end
  end

end
