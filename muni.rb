require 'net/http'
require 'rubygems'
require 'active_support'
require 'pp'
require 'ostruct'

class Train
end

class Muni
  API = "http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&"
  ROUTES = {
    'N'  => {:stop_id => 13911}, # Carl and Cole
    '6'  => {:stop_id => 17025}, # Masonic and Frederick
    '71' => {:stop_id => 14958}, # Masonic and Haight
  }

  class << self
    def fetch(route_id, stop_id)
      Net::HTTP.get(URI.parse("#{API}r=#{route_id}&stopId=#{stop_id}"))
    end
  end
end

Muni::ROUTES.each do |route, data|
  xml = Muni.fetch(route, data[:stop_id])
  predictions = Hash.from_xml(xml)['body']['predictions']

  puts predictions["routeTitle"]

  direction = predictions["direction"]
  if direction.is_a?(Array)
    direction.each {|d| puts d["title"]}
  else
    puts direction["title"]
  end
  
  puts
end