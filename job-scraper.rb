require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'
require 'active_support/core_ext/string'

class JobScraper

  def initialize(url, last_job_id)
    @last_job_id = last_job_id
    @page = Nokogiri::HTML(open(url))
    @last_page = @page.css('div.pagination a.job-link')[-2].text.to_i
  end

  def build_urls
   ["http://careers.stackoverflow.com/jobs?pg=1", "http://careers.stackoverflow.com/jobs?pg=2", "http://careers.stackoverflow.com/jobs?pg=3"]
   # urls = []
   # (1..@last_page).each {|n| urls << "http://careers.stackoverflow.com/jobs?pg=#{n}"} 
   #  urls
  end

  # def self.posted
  #   Time.now.strftime("%Y-%m-%d %H:%M:%S")
  # end

  def scrape
    @urls = build_urls
    index = 0
    job_already_scraped = false

    @urls.map do |url|
      unless job_already_scraped
        puts "Scraping page #{index + 1}"
        index += 1

        @page = Nokogiri::HTML(open(url))
        @rows = @page.css('.list.jobs div[data-jobid]')
        job_info = []

        @rows.each do |row|
          job_already_scraped = (row['data-jobid'] == @last_job_id)
          break if job_already_scraped

          job_info << { job_id: row['data-jobid'],
            title: row.css('a.job-link').first.text,
            description: row.css('p.description').text,
            url: row.css('a.job-link').first['href'],
            jscore: row.css('.joeltestscore').text.to_i,
            company_name: row.css('p.location span.employer').text.squish,
            location: row.css('p.location').text.split(' - ')[1].squish,
            tags: [row.css('a.post-tag.job-link').map(&:text)].flatten,
            # posted: posted
          }
        end
        job_info
      end
    end
  end

end