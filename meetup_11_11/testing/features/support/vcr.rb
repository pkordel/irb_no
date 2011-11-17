VCR.config do |c|
  c.stub_with :typhoeus
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_localhost = true
end

VCR.cucumber_tags do |t|
  t.tag "vcr"
end