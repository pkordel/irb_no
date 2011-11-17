Feature: VCR test
  Given I want to test features using vcr
  I want to make sure this works
  
  @vcr
  Scenario: Check the response
    Given a request is made to "http://www.iana.org/domains/example/"
    Then the response should match "Example Domains"