require 'nokogiri'
require 'open-uri'

class HtmlReader
  attr_accessor :document

  def initialize(url)
    html = open(url) { |result| result.read }
    @document = Nokogiri::HTML(html)
  end

  def self.doc
    @document
  end
end