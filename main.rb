require 'byebug'

require 'nokogiri'
require 'open-uri'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

page_number = 0

url_part1 = 'https://auction.conros.ru/clAuct/863/0/'
url_part2 = '/0/asc/'


url = url_part1 + page_number.to_s + url_part2
html = open(url) { |result| result.read }

document = Nokogiri::HTML(html)

table = document.at('table.productListing')

max_pages = document.css('table#maingrid.table.smallText').count
puts max_pages
#TD.smallText, SPAN.smallText, P.smallText
#  csv = []

#table.each do item
#table.css('tr.productListing-data').text
#end
#puts table.css('td.productListing-data, tr.productListing-data, a.productListing-data').count
#puts table.css('td.productListing-data, tr.productListing-data, a.productListing-data').count

current_path = File.dirname(__FILE__)
file_path = current_path + '/Data./file.csv'
f = File.open(file_path, 'w:UTF-8')


csv = table.css('tr.productListing-data').map { |n| n.text.gsub(/[\r\n         ]/, '') }


csv.each { |n| n.gsub(/[nbsp]/, ',') }
#puts csv.to_s

f.puts csv
page_number = page_number + 1

puts 'File wrote complete'
f.close

#{a:-webkit-any-link}
#puts table.css('tr.productListing-data').map { |n| n != '' }.count
#puts table.css('tr.productListing-data[50]').text
#puts html.inspect