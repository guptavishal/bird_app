require "rails_helper"

describe BirdsController, :type => :controller do

  before(:all) do
    Bird.delete_all
    @bird1 = Bird.create!(:name=>"name-1", :family => "family-1", :continents => [Continent.new(:name=>"c1")])
    @bird2 = Bird.create!(:name=>"name-2", :family => "family-2", :continents => [Continent.new(:name=>"c2")])
  end

  describe "GET #index" do

    it "responds successfully with an HTTP 200 status code with all birds" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
      birds_json = JSON.parse(response.body)
      expect(birds_json.length).to eq(2)
      expect([birds_json[0]["name"], birds_json[1]["name"] ]).to match_array([@bird1.name, @bird2.name])
      expect([birds_json[0]["id"], birds_json[1]["id"] ]).to match_array([@bird1._id.to_s, @bird2._id.to_s])
    end

  end

  describe "GET #show" do

    it "responds with HTTP 404 in case of invalid bird" do
      get :show, {:id => 1}
      expect(response).to have_http_status(404)
    end

    it "responds with HTTP 200 with valid bird" do
      get :show, {:id => @bird1._id.to_s}
      expect(response).to have_http_status(200)
      bird_json = JSON.parse(response.body)
      expect(bird_json["id"]).to eq(@bird1._id.to_s)
      expect(bird_json["name"]).to eq(@bird1.name)
    end

  end

  describe "POST #create" do

    it "responds with HTTP 201 and creates bird" do
      #original count of birds
      get :index
      birds_json = JSON.parse(response.body)
      original_count = birds_json.length
      #create the bird
      post :create, {:name => "name-9", :family => "family-9", :continents => ["c1", "c2"]}
      expect(response).to have_http_status(201)
      bird_json = JSON.parse(response.body)
      expect(bird_json["name"]).to eq("name-9")
      #new count of birds
      get :index
      birds_json = JSON.parse(response.body)
      expect(birds_json.length).to eq(original_count+1)
    end

    it "responds with HTTP 400 if mandatory fields not provided" do
      post :create, {}
      expect(response).to have_http_status(400)
    end

  end

  describe "DELETE #destroy" do

    it "responds with HTTP 200 and deletes bird" do
      #create new bird
      bird3 = Bird.create!(:name => "bird-3", :family => "family-3", :continents => [Continent.new(:name=>"c1")])
      get :index
      birds_json = JSON.parse(response.body)
      bird_count = birds_json.length
      #delete the bird
      delete :destroy, {:id => bird3._id.to_s}
      expect(response).to have_http_status(200)
      #GET API should return 2 birds
      get :index
      birds_json = JSON.parse(response.body)
      expect(birds_json.length).to eq(bird_count-1)
    end

    it "responds with HTTP 404 in case of invalid bird" do
      delete :destroy, {:id => 1}
      expect(response).to have_http_status(404)
    end

  end

end