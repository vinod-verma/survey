# Tendable Survey System
This Ruby script implements a simple survey system using the PStore gem for data persistence. Users are prompted with a series of questions and their Yes/No answers are recorded and used to calculate ratings for each run and an average rating across all runs.
### Installation
    1. Clone the repository.
    2. Ensure you have Ruby installed on your system.
    3. Install the required gems by running 'bundle install'.

### Usage
    1. Run the script using ruby survey.rb.
    2. Answer the prompted questions with Yes or No.

## Code Overview
### File Structure
    survey.rb: Main script file containing the survey functionality.
    spec/survey_spec.rb: Test cases of the survey code and functionality.
    Gemfile: Library dependencies to run the application.
    clear_data.rb: Contains code to delete the records from pstore.

### Dependencies
    PStore: A simple data store for Ruby objects.

### Survey Process
* ***Question Prompting:*** Users are prompted with a series of questions defined in the QUESTIONS hash.
* ***Answer Validation:*** User answers are validated to ensure they are either "yes" or "no".
* ***Ratings Calculation:*** Ratings are calculated based on the number of "yes" answers.
* ***Data Persistence:*** User answers and ratings are stored using PStore.
* ***Report Generation:*** A report is generated for each run, displaying the current run's rating and the average rating across all runs.

### Code Structure

* **Initialization:** Initializes the PStore and defines the list of survey questions.
* **User Interaction:**
    * ***do_prompt(store):*** Prompts users with questions and collects their answers.
    * ***validate_answer(answer):*** Validates user answers to ensure they are "yes" or "no".
* **Rating Calculation:**
    * ***calculate_ratings(answers):*** Calculates ratings based on user answers.
    * ***calculate_average_rating(store):*** Calculates the average rating across all runs.
* **Reporting:**
    * ***do_report(store, answers):*** Generates a report for the current run and displays ratings.

## Example
    require 'pstore'
    require_relative 'questionnaire'

    store = PStore.new("tendable.pstore")
    answers = do_prompt(store) # Collect user answers
    store.transaction { store[:answers] = answers } # Store answers in the PStore
    do_report(store, answers) # Generate and display a report based on the answers
    
## Additional Notes
> * The script handles user input validation to ensure data integrity.
> * Ratings are stored persistently using PStore for future analysis.

# Testing App
    Run: rspec # from terminal to run the test case
