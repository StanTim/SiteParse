require 'byebug'

require 'nokogiri'
require 'open-uri'

#require_relative 'UrlData'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Номер аукциона
auction_number = 864

# Таблица с результатами аукциона содержится на нескольких
# страницаз сайта. В адресе меняется только одна цифра

# Номер страницы содержится в середине адреса,
# поэтому разобьём адресную строку на три части -
# две статические и две переменную в серединке =)
url_part1 = 'https://auction.conros.ru/clAuct/'
url_part2 = '/0/'
url_part3 = '/0/asc/'

# зададим номер страницы для первого адреса текущего аукциона
# # Всего страниц на аукционе №1005 = 80, включая 0

while auction_number >= 0

# Номер страницы содержится в середине адреса,
# поэтому разобьём адресную строку на три части -
# две статические и одну переменную в серединке =)

  url = url_part1 + auction_number.to_s + url_part2 + '0' + url_part3

  html = open(url) { |result| result.read }
  document = Nokogiri::HTML(html)

# Надо посчитать сколько всего страниц на данном аукционе
  links = document.css('a.page_link').count / 2 - 2

  page_number = links

  while page_number >= 0 do

    url1 = url_part1 + auction_number.to_s + url_part2 + page_number.to_s + url_part3
    html1 = open(url1) { |result| result.read }
    document1 = Nokogiri::HTML(html1)

# Парсинг таблицы результатов аукционов
    table = document1.at('table.productListing')

# Привяжем название файла результатов к номеру аукциона
# оставив только номер, например, - 1005.csv

    file_name = document1.at('head > title').text.gsub(/\D/, '')

# Сохраним в папку Data файлы с данными таблиц аукционов
# Создание с дозаписывание, так, что необходимо убедиться,
# что файлы чистые.

    current_path = File.dirname(__FILE__)
    file_path = current_path + '/Data./' + file_name + '.csv'
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

      # Сформируем строку в файл с интервалами 1хTAB в порядке как столбцы на сайте
      f.puts %( #{lot} ; #{nominal} ; #{year} ; #{symbols} ; #{metal} ; #{save} ; #{bets} ; #{leader} ; #{price} )
      # переключим парсинг на следующую страницу аукциона

    end
    page_number -= 1
    f.close
  end
  puts "The file #{file_name}.csv recording is completely finished!"
# выполним парсинг для следующего аукциона
  auction_number -= 1
end
