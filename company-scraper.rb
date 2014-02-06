require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'

class CompanyScraper

	def initialize(url)
		@page = Nokogiri::HTML(open(url))
		@last_page = @page.css('div.pagination a.job-link')[-2].text.to_i
	end

	def build_urls
		["http://careers.stackoverflow.com/jobs/companies?pg=1", "http://careers.stackoverflow.com/jobs/companies?pg=2" ]
		# urls = []
		# (1..5).each {|n| urls << "http://careers.stackoverflow.com/jobs/companies?pg=#{n}"} 
		# urls
	end

	def company_urls
		urls = build_urls
		company_urls = []
		urls.map do |url|
		  page = Nokogiri::HTML(open(url))
		  company_urls << page.css('.list.companies a.title').map {|x| "http://careers.stackoverflow.com/uk" + x['href']}
		  company_urls.flatten!
		end
		company_urls
	end


	def scrape
		@company_urls = company_urls

		index = 1
		@company_urls.map do |company_url|

			puts "Getting page #{index}"
			index += 1

		  page = Nokogiri::HTML(open(company_url))

		    { name: page.css('h1').text,
		      avatar: (page.css('div.logo-container img').first['src'] rescue nil),
		      size: (page.css('table.basics tr').first.children[1].text rescue nil),
		      status: (page.css('table.basics tr')[1].children[1].text rescue nil),
		      founded: (page.css('table.basics tr')[2].children[1].text.to_i rescue nil),
		      url: (page.css('a.cp-links-url').text rescue nil),
		      company_id: company_url.split('/').last,
		      tags: (page.css('div.tags span.post-tag').map(&:text) rescue []),
		      benefits: (page.css('div.benefits-list span.benefit').map(&:text) rescue []),
		      jobs: (page.css('div.job a').map {|link| link[:href][/\d+/]} rescue [])
		    }
		end
	end

	def self.scrape_jobs(job_ids)
		job_ids.each do |job_id|
			url = 'http://careers.stackoverflow.com/jobs/' + job_id
			page = Nokogiri::HTML(open(url))
			{
				job_id: job_id,
				title: page.css('h1.title').text,
				description: (""),
				url: url,
				jscore: "",
				location: page.css('span.location').text,
				company: page.css('a.employer').text,
				tags: [row.css('a.post-tag.job-link').map(&:text)].flatten
			}
		end
	end

end


