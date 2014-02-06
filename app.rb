require 'grape'
require 'grape-entity'
require 'data_mapper'
require 'dm-ar-finders'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'

# class JobEntity < Grape::Entity

# end

def j(jobs)
  present jobs, with: Job::Entity
end

class StackAPI < Grape::API
  format :json
  default_format :json
  prefix 'api'

  desc "Returns a list of jobs."
  get :jobs do
    j Job.all
  end

  desc "Returns a list of companies."
  get :companies do
    Company.all
  end

  desc "Returns a list of jobs where relocation is offered."
  get :relocation do
    Job.find_by_sql("SELECT * FROM jobs WHERE location ILIKE '%(relocation offered)%'")
  end

  desc "Returns a list of jobs where remote working is allowed."
  get :remote do
    Job.find_by_sql("SELECT * FROM jobs WHERE location ILIKE '%(allows remote)%'")
  end

  desc "Returns a list of senior level jobs."
  get :senior do
    Job.find_by_sql("SELECT * FROM jobs WHERE title ILIKE '%senior%'")
    # Job.find_by_sql("SELECT * FROM jobs WHERE title SIMILAR TO '%(S|s)enior%'")
  end

  resource :jobs do
    params do
      requires :id, type: Integer, desc: "Job id."
    end
    route_param :id do
      get do
        Job.first(job_id: params[:id])
      end
    end
  end

  # puts routes

end

