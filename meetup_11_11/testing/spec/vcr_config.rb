require 'vcr'
require 'typhoeus'

VCR.config do |c|
  c.stub_with :typhoeus
  c.cassette_library_dir     = 'spec/cassettes'
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
