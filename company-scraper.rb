require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = 'http://careers.stackoverflow.com/company/workshare'

page = Nokogiri::HTML(open(url))

company = { name: page.css('h1').text,
            avatar: page.css('div.logo-container img').first['src'],
            size: page.css('table.basics tr').first.children[1].text,
            status: page.css('table.basics tr')[1].children[1].text,
            founded: page.css('table.basics tr')[2].children[1].text,
            url: page.css('a.cp-links-url').text,
            tags: page.css('div.tags span.post-tag').map(&:text),
            benefits_list: page.css('div.benefits-list span.benefit').map(&:text),
            jobs: page.css('div.job a').map {|link| link[:href][/\d+/] }
          }
