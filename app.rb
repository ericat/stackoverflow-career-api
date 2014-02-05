require 'grape'
require 'data_mapper'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'

class StackAPI < Grape::API
  format :json
  default_format :json
  prefix 'api'

  desc "Returns a list of jobs."
  get :jobs do
    Job.first(10)
  end

end

