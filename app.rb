require 'grape'
require 'data_mapper'
require 'dm-ar-finders'
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
    Job.all
  end

  desc "Returns a list of jobs by location"
  get :kumi do
    Job.find_by_sql("SELECT * FROM jobs")
  end

  # desc "Returns a single job."
  # params do
  #   requires :jobs, type: Integer, desc: "Job id."
  # end
  # route_param :job_id do
  #   get do
  #     Job.first(params[:job_id])
  #   end
  # end

  desc "Returns a list of companies."
  get :companies do
    Company.all
  end

  # puts routes.inspect

end

