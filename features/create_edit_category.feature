Feature: Create and edit categories
  As a blog administrator
  I want to be able to add and edit
  blogging categories.

  Background:
    Given the blog is set up
    And I am logged into the admin panel

  When I follow "Categories"
  Scenario: Categories page should load 
    Then I should see "Categories"
    And I should see "Permalink"
    And I should see "General"
  Scenario: It should be possible to create new categories
    When I fill in "Name" with "My Category"
    And I press "Save"
    Then I should see "My Category"
    And I should see "no articles"
  Scenario: It should be possible to edit existing categories
    When I follow "General"
    Then I fill in "Description" with "test1, test2, test3"
    And I press "Save"
    Then I should see "test1"
