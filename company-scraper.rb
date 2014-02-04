require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'

class CompanyScraper

	def initialize(url)
		# url = 'http://careers.stackoverflow.com/jobs/companies'
		@page = Nokogiri::HTML(open(url))
		@last_page = @page.css('div.pagination a.job-link')[-2].text.to_i
	end

	def build_urls
		# urls = ["http://careers.stackoverflow.com/jobs/companies?pg=1", "http://careers.stackoverflow.com/jobs/companies?pg=2" ]
		urls = []
		(1..@last_page).each {|n| urls << "http://careers.stackoverflow.com/jobs/companies?pg=#{n}"} 
		urls
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
		# pp @company_urls

		@company_urls.map do |company_url|

		  page = Nokogiri::HTML(open(company_url))

		    { name: page.css('h1').text,
		      avatar: page.css('div.logo-container img').first['src'],
		      size: (page.css('table.basics tr').first.children[1].text rescue nil),
		      status: (page.css('table.basics tr')[1].children[1].text rescue nil),
		      founded: (page.css('table.basics tr')[2].children[1].text rescue nil),
		      url: page.css('a.cp-links-url').text,
		      id: company_url.split('/').last,
		      tags: page.css('div.tags span.post-tag').map(&:text),
		      benefits_list: page.css('div.benefits-list span.benefit').map(&:text),
		      jobs: page.css('div.job a').map {|link| link[:href][/\d+/] }
		    }
		end
	end

end


# pp CompanyScraper.new("http://careers.stackoverflow.com/jobs/companies").scrape


