class BirdsController < ApplicationController

  protect_from_forgery

  def index
    @birds = Bird.all
    render :json => Rabl.render(@birds, 'birds/index', :view_path => 'app/views')
  end

  def create
    begin
      continents = []
      if not params[:continents].blank?
        params[:continents].each do |c|
          continents << Continent.new(:name => c)
        end
      end
      @bird = Bird.create!(:name => params[:name], :family => params[:family],
                           :added => params[:added], :visible => params[:visible],
                           :continents => continents)
      render :json => Rabl.render(@bird, 'birds/create', :view_path => 'app/views'), :status => 201
    rescue Exception => e
      render(:status => 400,
             :json => {:error => {:error_code => 400, :error_message => "#{e.message}"}})
      return
    end
  end

  def show
    begin
      @bird = Bird.find(params[:id])
      render :json => Rabl.render(@bird, 'birds/show', :view_path => 'app/views')
      return
    rescue Mongoid::Errors::DocumentNotFound
      render(:status => 404,
             :json => {:error => {:error_code => 404, :error_message => "There is no bird with id #{params[:id]}."}})
      return
    end
  end

  def destroy
    begin
      @bird = Bird.find(params[:id])
      @bird.delete
      render :status => 200, :nothing => true
      return
    rescue Mongoid::Errors::DocumentNotFound
      render(:status => 404,
             :json => {:error => {:error_code => 404, :error_message => "There is no bird with id #{params[:id]}."}})
      return
    end
  end

end
