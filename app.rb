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

  desc "Returns a list of companies."
  get :companies do
    Company.all
  end

  desc "Returns a list of jobs where relocation is offered."
  get :relocation do
    Job.find_by_sql("SELECT * FROM jobs WHERE location LIKE '%(relocation offered)%'")
  end

  desc "Returns a list of jobs where remote working is allowed."
  get :remote do
    Job.find_by_sql("SELECT * FROM jobs WHERE location LIKE '%(allows remote)%'")
  end

  desc "Returns a list of senior level jobs."
  get :senior do
    Job.find_by_sql("SELECT * FROM jobs WHERE title LIKE '%senior%' OR title like '%Senior%'")
    # Job.find_by_sql("SELECT * FROM jobs WHERE title REGEXP '(S|s)enior'")
  end


  # desc "Returns a single job."
  # params do
  #   requires :jobs, type: String, desc: "Job id."
  # end
  # route_param :job_id do
  #   get do
  #     Job.first(params[:job_id])
  #   end
  # end

  puts routes

end

