require 'data_mapper'
require 'open-uri'
require 'grape-entity'
require 'nokogiri'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'
require_relative 'job-scraper'
require_relative 'company-scraper'

def parse_jobs(pages)
  scraping_round = Job.last ? Job.last.scraping_round + 1 : 1

  pages.compact.each_with_index do |jobs, index|
    puts "Parsing page #{index + 1}"
    jobs.each do |job_info|
      tag_names = job_info.delete(:tags)
      job_info[:scraping_round] = scraping_round
      # Job.raise_on_save_failure = true
      job = Job.create(job_info)
      raise job.errors.inspect if job.errors.any?
      if tag_names
        tag_names.each do |tag_name|
          job.tags << Tag.first_or_create(name: tag_name)
          job.save
        end
      end
    end
  end
end

def parse_companies(pages)
  scraping_round = Company.last ? (Company.last.scraping_round || 0) + 1 : 1

   @jobs_links = []
   pages.each do |company_info|
    company_info[:scraping_round] = scraping_round
    tag_names = company_info.delete(:tags)
    benefits = company_info.delete(:benefits)
    jobs = company_info.delete(:jobs)

    company = Company.create(company_info)
    puts company_info
    raise company.errors.inspect if company.errors.any?

    if tag_names
      tag_names.each do |tag_name|
        company.tags << Tag.first_or_create(name: tag_name)
      end
    end

    if benefits
      benefits.each do |benefit|
        company.benefits << Benefit.first_or_create(name: benefit)
        company.save
      end
    end

    if jobs
      jobs.each do |job_id|
        job = Job.first(job_id: job_id)      
        if job
          puts 'saving job'
          job.company = company
          job.save
        else
          puts "WARN: job not in DB: #{job_id}"
          Job.create(job_id: job_id, title: "Job Missing", company: company)
        end
      end
    end
  end
end


desc "Upgrade database"
task :auto_upgrade do
  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

desc "Migrate database"
task :auto_migrate do
  DataMapper.auto_migrate!
  puts "Auto-migrate complete"
end

desc "Get most recent jobs and save to database"
task :scrape_jobs do
  last_job_id = Job.first(:order => [:scraping_round.desc]).job_id.to_s rescue nil
  pages = JobScraper.new('http://careers.stackoverflow.com/jobs', last_job_id).scrape
  parse_jobs(pages)
end

desc "Get most recent companies and save to database"
task :scrape_companies do
  last_company_id = Company.first(:order => [:scraping_round.desc]).company_id.to_s rescue nil
  pages = CompanyScraper.new('http://careers.stackoverflow.com/jobs/companies', last_company_id).scrape
  parse_companies(pages)
end

desc "Scrape jobs not in db"
task :jobs_not_in_db do
  job_ids = Job.all(:title => "Job Missing").map(&:job_id)
  jobs = CompanyScraper.scrape_jobs(job_ids)
  jobs.each do |job_info|
    tag_names = job_info.delete(:tags)
    job = Job.first(job_id: job_info[:job_id])
    job.update(job_info)
    raise job.errors.inspect if job.errors.any?

    if tag_names
      tag_names.each do |tag_name|
        job.tags << Tag.first_or_create(name: tag_name)
        job.save
      end
    end
  end
end

desc "Refresh jobs database"
task :refresh_jobs do
  JobTag.destroy
  Job.destroy
  pages = JobScraper.new('http://careers.stackoverflow.com/jobs').scrape
  parse_jobs(pages)
end

desc "Refresh companies database"
task :refresh_companies do
  CompanyTag.destroy
  Company.destroy
  pages = CompanyScraper.new('http://careers.stackoverflow.com/jobs/companies').scrape
  parse_companies(pages)
end

desc "Pings PING_URL to keep a dyno alive"
task :dyno_ping do
  require "net/http"

  if ENV['PING_URL']
    uri = URI(ENV['PING_URL'])
    Net::HTTP.get_response(uri)
  end
end

















