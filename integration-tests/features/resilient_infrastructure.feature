Feature: Resilient storage

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check if user is logged in the OpenShift
    Given The OpenShift Client is installed
    When I run OC command to show information about the current session
    Then I should get the user name

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check if the f8a-server-backbone is deployed and running
    Given The OpenShift Client is installed
    When I ask for statuses of all deployments
    Then I should find that the deployment f8a-server-backbone exists
    When I ask for status of the f8a-server-backbone service
    Then I should find that the service f8a-server-backbone exists

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check if the f8a-license-analysis is deployed and running
    Given The OpenShift Client is installed
    When I ask for statuses of all deployments
    Then I should find that the deployment f8a-license-analysis exists
    When I ask for status of the f8a-license-analysis service
    Then I should find that the service f8a-license-analysis exists

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check if the bayesian-pgbouncer is deployed and running
    Given The OpenShift Client is installed
    When I ask for statuses of all deployments
    Then I should find that the deployment bayesian-pgbouncer exists
    When I ask for status of the bayesian-pgbouncer service
    Then I should find that the service bayesian-pgbouncer exists

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check if we are able to restart the f8a-server-backbone service
    Given The OpenShift Client is installed
    When I ask for statuses of all deployments
    Then I should find that the deployment f8a-server-backbone exists
    When I ask for status of the f8a-server-backbone service
    Then I should find that the service f8a-server-backbone exists
    When I get all pods for the f8a-server-backbone service
    Then I should find at least 1 pod
     And I should find that all pods are in the Running state
    When I delete all pods for the service f8a-server-backbone
     And I wait 10 seconds
     And I get all pods for the f8a-server-backbone service
    Then I should find that none of pods are in the Running state
    When I wait for the service f8a-server-backbone to restart with timeout set to 10 minutes
     And I get all pods for the f8a-server-backbone service
    Then I should find at least 1 pod
     And I should find that all pods are in the Running state

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check what happens to server when the f8a-server-backbone is restarted
    Given The OpenShift Client is installed
    When I access the /api/v1/ 30 times with 2 seconds delay
    Then I should get 200 status code for all calls
    When I delete all pods for the service f8a-server-backbone
     And I access the /api/v1/ 30 times with 2 seconds delay
    Then I should get 200 status code for all calls

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Check that the stack-analyses works (nothing more ATM)
    Given System is running
    When I acquire the authorization token
    Then I should get the proper authorization token
    When I wait 10 seconds
    When I send Maven package manifest pom-effective.xml to stack analysis version 3 with authorization token
    Then I should get 200 status code
     And I should receive JSON response with the correct id
    When I wait for stack analysis to finish with authorization token
    Then I should get 200 status code
     And I should get a valid request ID
     And I should find the attribute request_id equals to id returned by stack analysis request

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Now let's try to kill the f8a-server-backbone during the stack analyses
    Given System is running
     And The OpenShift Client is installed
    When I acquire the authorization token
    Then I should get the proper authorization token
    When I wait 10 seconds
    When I send Maven package manifest pom-effective.xml to stack analysis version 3 with authorization token
    Then I should get 200 status code
     And I should receive JSON response with the correct id
    When I delete all pods for the service f8a-server-backbone
     And I wait for stack analysis to finish with authorization token
    Then I should get 200 status code
     And I should get a valid request ID
     And I should find the attribute request_id equals to id returned by stack analysis request

  @requires.openshift.console.access
  @resilient.infrastructure
  Scenario: Now let's try to kill the f8a-server-backbone right BEFORE the stack analyses
    Given System is running
     And The OpenShift Client is installed
    When I acquire the authorization token
    Then I should get the proper authorization token
    When I wait 10 seconds
     And I delete all pods for the service f8a-server-backbone
     And I send Maven package manifest pom-effective.xml to stack analysis version 3 with authorization token
    Then I should get 200 status code
     And I should receive JSON response with the correct id
    When I wait for stack analysis to finish with authorization token
    Then I should get 200 status code
     And I should get a valid request ID
     And I should find the attribute request_id equals to id returned by stack analysis request

