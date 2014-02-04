require 'data_mapper'
require 'open-uri'
require 'nokogiri'
require './lib/benefit'
require './lib/company'
require './lib/job'
require './lib/tag'
require_relative 'data_mapper_setup'
require_relative 'job-scraper'
require_relative 'company-scraper'

desc "Upgrade database"
task :auto_upgrade do
  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

desc "Migrate database"
task :auto_migrate do
  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data could have been lost)"
end

desc "Get jobs"
task :scrape_jobs do
  @job_pages = JobScraper.new('http://careers.stackoverflow.com/jobs').scrape

  @job_pages.each_with_index do |jobs, index|

    puts "Parsing page #{index + 1}"

    jobs.each do |job_info|

      tag_names = job_info.delete(:tags)
      company = job_info.delete(:company)

      # Job.raise_on_save_failure = true
      job = Job.create(job_info)
      raise job.errors.inspect if job.errors.any?

      if tag_names
        tag_names.each do |tag_name|
          job.tags << Tag.first_or_create(name: tag_name)
        end
      end

    end
  end
end

desc "Get companies"
task :scrape_companies do
  @companies = CompanyScraper.new('http://careers.stackoverflow.com/jobs/companies').scrape
  @companies.each do |company_info|

    tag_names = company_info.delete(:tags)
    benefits = company_info.delete(:benefits_list)
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
          puts 'WARN: job not in DB'
          puts job_id
        end
      end
    end
  end

end
















