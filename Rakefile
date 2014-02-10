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
      # company = job_info.delete(:company)
      job_info[:scraping_round] = scraping_round
      Job.raise_on_save_failure = true
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

desc "Get most recent jobs and save them to database"
task :scrape_jobs do
  last_job_id = Job.first(:order => [:scraping_round.desc]).job_id.to_s rescue nil
  pages = JobScraper.new('http://careers.stackoverflow.com/jobs', last_job_id).scrape
  parse_jobs(pages)
end

desc "Refresh jobs database"
task :refresh_jobs do
end

desc "Refresh companies database"
task :refresh_companies do
end

desc "Get companies"
task :scrape_companies do

  @jobs_links = []
  @companies = CompanyScraper.new('http://careers.stackoverflow.com/jobs/companies').scrape
  @companies.each do |company_info|

    tag_names = company_info.delete(:tags)
    benefits = company_info.delete(:benefits)
    jobs = company_info.delete(:jobs)

    company = Company.create(company_info)

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
          @jobs_links << job_id
          @jobs_links
        end
      end
    end
  end
  
  # puts @jobs_links.inspect

end
















