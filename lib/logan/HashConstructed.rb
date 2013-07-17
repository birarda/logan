module HashConstructed
 def initialize(h)
  h.each { |k,v| send("#{k}=",v) if respond_to?("#{k}=") } 
 end
end