require 'grape'
require 'grape-entity'
require 'data_mapper'
require 'dm-ar-finders'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'
require_relative 'data_mapper_custom'

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
          tags = params[:id].split('&')
          show_jobs(Tag.all(name: tags).map(&:jobs).flatten)
          # show_jobs(Tag.all(:name.ilike => "#{tags}").map(&:jobs).flatten)
        end
      end
    end
    desc "Returns a list of jobs by location"
    resource :location do
      params do 
        requires :id, type: String, desc: "Location"
      end
      route_param :id do
        get do
          location = params[:id]
          show_jobs(Job.all(:location.ilike => "%#{location}%"))
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
          tags = params[:id].split('&')
          show_companies(Tag.all(name: tags).map(&:companies).flatten)
        end
      end
    end

    desc "Returns a list of companies by benefits keywords"
    resource :benefits do
      params do
        requires :id, type: String, desc: "Benefits"
      end
      route_param :id do
        get do
          benefit_names = params[:id].split('&')
          benefits = benefit_names.map { |benefit| Benefit.first(:name.ilike => "%#{benefit}%") }
          show_companies(Company.all(benefits: benefits.flatten))
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
  end

  desc "Return a list of full stack jobs"
  get :full_stack do
    show_jobs(Job.find_by_sql("SELECT * FROM jobs WHERE title SIMILAR TO '%((F|f)ull(\s)(S|s)tack)%'"))
  end
  # puts routes

end

