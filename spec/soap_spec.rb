require 'spec_helper'

client = StirSpec::WhoIsClient.new
message = { 'HostName' => "manheim.com" }
client.operations # a list of valid operation names from the service
response = client.get_who_is(message) #call method directly, since we defined it
binding.pry
#response object will be the full response from savon
response.body # this is how you ge the straight up body only
client.stupid_string_response#defining a value out of the response body
response.http.code #and here is the status code of the response
response.http.headers # here be the headers

