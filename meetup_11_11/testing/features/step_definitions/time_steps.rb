Given /^the date is "([^"]*)"$/ do |date_string|
  Timecop.travel Chronic.parse(date_string)
end

