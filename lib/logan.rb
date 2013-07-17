require "httparty"
Dir[File.dirname(__FILE__) + '/logan/*.rb'].each do |file|
  require file
end