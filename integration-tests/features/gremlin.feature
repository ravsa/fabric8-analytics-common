Feature: Check the Gremlin instance and its behaviour

  Scenario: Check that the Gremlin is available
    Given System is running
    When I access Gremlin API
    Then I should get 200 status code
    Then I should get valid Gremlin response

  Scenario: Basic check for Gremlin ability to find vertexes
    Given System is running
    When I ask Gremlin to find all vertexes having property vertex_label set to foobar
    Then I should get 200 status code
     And I should get valid Gremlin response
     And I should get 0 vertexes
