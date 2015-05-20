# this module is taken from the accepted answer here
# http://stackoverflow.com/questions/1572660/is-there-a-way-to-initialize-an-object-through-a-hash

module HashConstructed

  attr_accessor :attributes, :json_raw

  # initalizes the object by pulling key-value pairs from the hash and
  # mapping them to the object's instance variables
  #
  # @param [Hash] h hash containing key-value pairs to map to object instance variables
  def initialize(h)
    @attributes = h
    h.each do |k,v|
      next unless respond_to?("#{k}=")
      send("#{k}=",v)
    end
  end
end