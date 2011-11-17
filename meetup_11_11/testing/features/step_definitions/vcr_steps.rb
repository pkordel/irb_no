require 'typhoeus'

When /^a request is made to "([^"]*)"$/ do |url|
  @response = Typhoeus::Request.get(url)
end

Then /^the response should match "([^"]*)"$/ do |expected_response|
  @response.body.to_s.should match expected_response
end
