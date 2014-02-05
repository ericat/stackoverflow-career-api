require 'sinatra'
require 'sinatra/base'
require 'grape'
require 'data_mapper'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'

# class StackAPI < Grape::API
#   format :json
#   default_format :json
#   # prefix 'api'

#   desc "Returns a list of jobs."
#   get :jobs do
#    Job.all #serialized data here
#   end

# end

# class API < Sinatra::Base

  get '/jobs' do
   Job.all.to_json #serialized data here
  end

  # get '/companies' do
  # end

  # get '/companies/:id' do
  # end

  # get '/jobs/:id' do
  #  {your stuff as JSON }
  #  error!() unless
  # end

# end

