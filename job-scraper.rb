require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = 'http://careers.stackoverflow.com/jobs'

page = Nokogiri::HTML(open(url))

rows = page.css('.list.jobs div[data-jobid]')

def posted
  Time.now
end

rows.map do |row| 
  { job_id: row['data-jobid'],
    title: row.css('a.job-link').first.text,
    url: row.css('a.job-link').first['href'],
    jscore: row.css('.joeltestscore').text,
    company: row.css('p.location').text.split(' - ')[0].strip!,
    location: row.css('p.location').text.split(' - ')[1].strip!,
    tags: [row.css('a.post-tag.job-link').map(&:text)].flatten,
  # posted: posted
  }
end



