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
# Таблица с результатами аукциона содержится на нескольких
# страницаз сайта. В адресе меняется только одна цифра
# зададим номер страницы для первого адреса
page_number = 0

# Всего страниц на аукционе №1005 = 80, включая 0
while page_number <= 80

  # Номер страницы содержится ы середине адреса,
  # поэтому разобьё адресную строку на три части -
  # две статические и одну переменную в серединке =)

  url_part1 = 'https://auction.conros.ru/clAuct/863/0/'
  url_part2 = '/0/asc/'

  url = url_part1 + page_number.to_s + url_part2

  html = open(url) { |result| result.read }

  document = Nokogiri::HTML(html)

  table = document.at('table.productListing')

#Надо посчитать сколько всего страниц на данном аукционе
#links = document.css('a.page_link').count
links = document.css('a.page_link').count
puts links/2 - 2

#puts links.css('tbody.tr.td').count
#max_pages = links.css('').count
#puts max_pages
#TD.smallText, SPAN.smallText, P.smallText

#table.each do item
#table.css('tr.productListing-data').text
#end
#puts table.css('td.productListing-data, tr.productListing-data, a.productListing-data').count
#puts table.css('td.productListing-data, tr.productListing-data, a.productListing-data').count

  current_path = File.dirname(__FILE__)
  file_path = current_path + '/Data./1005.csv'
  f = File.open(file_path, 'a+:UTF-8')

  table.css('tr.productListing-data').map do |n|
    lot = n.css('td')[0].text
    nominal = n.css('td')[1].text
    year = n.css('td')[2].text
    symbols = n.css('td')[3].text
    metal = n.css('td')[4].text
    save = n.css('td')[5].text
    bets = n.css('td')[6].text
    leader = n.css('td')[7].text
    price = n.css('td')[8].text

    f.puts %(#{lot}  #{nominal}  #{year}  #{symbols}  #{metal}  #{save} #{bets} #{leader} #{price})

  end
  f.close
  page_number += 1

end

puts 'File wrote complete'


#{a:-webkit-any-link}
#puts table.css('tr.productListing-data').map { |n| n != '' }.count
#puts table.css('tr.productListing-data[50]').text
#puts html.inspect