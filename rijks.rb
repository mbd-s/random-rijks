require 'httparty'
require 'dotenv'
Dotenv.load

class Rijks
  include HTTParty

  base_uri "https://www.rijksmuseum.nl/api/en/collection"
  default_params :key => ENV['rijksmuseum_api_key'], :format => "json"

  attr_accessor :query

  def initialize(query)
    self.query = query
  end

  #given a search input, searches the Rijksmuseum API for the query and returns a random page from the results
  def self.random_page_search query
    response = get("?q=#{ query }&imgonly=true&ps=10")
    if response.success?
      count = response["count"]
      number_of_search_pages = (count / 10).round
      result_page = rand(1..number_of_search_pages)
      random_page = get("?q=#{ query }&p=#{ result_page }&imgonly=true&ps=10")
      random_page
    else
      raise response.response
    end
  end
end

random_textile_page = Rijks.random_page_search "textile"
random_textile_image = random_textile_page["artObjects"][rand(0..9)]["webImage"]["url"]
puts random_textile_image
