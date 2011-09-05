require "net/http"
require "uri"

class Sms 
	
  def initialize(breed, name)  
    # Instance variables  
    @to = breed  
    @msg = name  
  end 
	
	def send  
		uri = URI.parse("http://bhashsms.com/api/sendmsg.php?user=sramdass&pass=damayan7&sender=sramdass&phone=#{@to}&text=#{@msg}&priority=dnd&stype=normal")
		
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		
		response = http.request(request)
		
		response.code + response.body 
	end  
end 