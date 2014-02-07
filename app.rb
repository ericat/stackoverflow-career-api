require 'grape'
require 'grape-entity'
require 'data_mapper'
require 'dm-ar-finders'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'

  def show_jobs(jobs)
    present jobs, with: Job::Entity
  end

def show_companies(companies)
  present companies, with: Company::Entity
end

class StackAPI < Grape::API
  format :json
  default_format :json
  prefix 'api'

  
  desc "Returns a list of jobs."
  get :jobs do
    show_jobs(Job.all)
  end

  desc "Return a single job."
  resource :jobs do
    params do
      requires :id, type: String, desc: "Job id."
    end
    route_param :id do
      get do
        show_jobs(Job.first(job_id: params[:id]))
      end
    end

    desc "Return a list of jobs by a tag from user query."
    resource :tags do
      params do
        requires :id, type: String, desc: "Tag."
      end
      route_param :id do
        get do
          Tag.first(name: params[:id]).jobs
        end
      end
    end
  end

  desc "Returns a list of companies."
  get :companies do
    show_companies(Company.all)
  end

  desc "Returns a single company."
  resource :companies do
    params do
      requires :id, type: String, desc: "Company id."
    end
    route_param :id do
      get do
        show_companies(Company.first(company_id: params[:id]))
      end
    end
    desc "Returns a list of companies by a tag"
    resource :tags do
      params do
        requires :id, type: String, desc: "Tag."
      end
      route_param :id do
        get do
          Tag.first(name: params[:id]).companies
        end
      end
    end
  end

  desc "Returns a list of jobs where relocation is offered."
  get :relocation do
    show_jobs(Job.find_by_sql("SELECT * FROM jobs WHERE location ILIKE '%(relocation offered)%'"))
  end

  desc "Returns a list of jobs where remote working is allowed."
  get :remote do
    show_jobs(Job.find_by_sql("SELECT * FROM jobs WHERE location ILIKE '%(allows remote)%'"))
  end

  desc "Returns a list of senior level jobs."
  get :senior do
    show_jobs(Job.find_by_sql("SELECT * FROM jobs WHERE title ILIKE '%senior%'"))
    # Job.find_by_sql("SELECT * FROM jobs WHERE title SIMILAR TO '%(S|s)enior%'")
  end

  desc "Return a list of full stack jobs"
  get :full_stack do
    Job.find_by_sql("SELECT * FROM jobs WHERE title SIMILAR TO '%((F|f)ull(\s)(S|s)tack)%'")
  end


  puts routes

end

