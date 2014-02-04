require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = 'http://careers.stackoverflow.com/jobs'
page = Nokogiri::HTML(open(url))

last_page = page.css('div.pagination a.job-link')[-2].text.to_i

# urls = []
(1..last_page).each {|n| urls << "http://careers.stackoverflow.com/jobs?pg=#{n}"} 

urls = ["http://careers.stackoverflow.com/jobs?pg=1", "http://careers.stackoverflow.com/jobs?pg=2", "http://careers.stackoverflow.com/jobs?pg=3"]

rows = page.css('.list.jobs div[data-jobid]')




# rows.map do |row| 
#   { job_id: row['data-jobid'],
#     title: row.css('a.job-link').first.text,
#     description: row.css('p.description').text,
#     url: row.css('a.job-link').first['href'],
#     jscore: row.css('.joeltestscore').text,
#     company: row.css('p.location').text.split(' - ')[0].strip!,
#     location: row.css('p.location').text.split(' - ')[1].strip!,
#     tags: [row.css('a.post-tag.job-link').map(&:text)].flatten,
#   # posted: posted
#   }
# end



