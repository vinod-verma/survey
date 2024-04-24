require 'byebug'
require "pstore" # https://github.com/ruby/pstore

# Initializing PStore with it name
STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

# List of question to ask in survey
QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# Prompts the user with a series of questions and collects their Yes/No answers.
#
# Parameters:
# - store: the PStore object used for persisting data
#
# Returns:
# - A hash containing the user's answers, where keys are question identifiers and values are the validated Yes/No responses.
#
# Example:
#   store = PStore.new("tendable.pstore")
#   user_answers = do_prompt(store)
#   # => { q1: "yes", q2: "no", q3: "yes" } (user's responses to each question)
#
def do_prompt(store)
  answers = {}
  QUESTIONS.each do |key, question|
    print "#{question} (Yes/No): "
    answer = gets.chomp.downcase
    validate_answer(answer)
    answers[key] = answer
  end
  answers
end

# Validates the user's answer to ensure it is one of the accepted values: "yes", "no", "y", or "n".
#
# Parameters:
# - answer: a string representing the user's input
#
# Returns:
# - A validated answer as a lowercase string ("yes", "no", "y", or "n")
#
# Example:
#   user_input = "Yes"
#   validated_answer = validate_answer(answer)
#   # => "yes" (normalized and validated input)
#
def validate_answer(answer)
  valid_answers = ["yes", "no", "y", "n"]
  answer = answer.downcase.strip # Normalize the input
  until valid_answers.include?(answer)
    print "Invalid answer. Please enter Yes or No: "
    answer = gets.chomp.downcase.strip
  end
  answer # Return the valid answer
end 

# Calculates the ratings based on the provided answers.
# 
# Parameters:
# - answers: a hash containing the answers where the keys are question identifiers and the values are the user responses ("yes" or "no")
# 
# Returns:
# - An integer representing the calculated ratings based on the number of "yes" and "y" answers, divided by the total number of questions.
#
# Example:
#   answers = { q1: "yes", q2: "no", q3: "yes" }
#   calculate_ratings(answers)
#   # => 40 (2 "yes" answers out of 5 questions)
#
def calculate_ratings(answers)
  answers_values = answers.values
  yes_count = answers_values.count("yes")
  y_count = answers_values.count("y")
  ( yes_count + y_count ) * 100 / QUESTIONS.size
end

# Calculates the average rating based on the total ratings stored in the PStore.
#
# Parameters:
# - store: the PStore object used for persisting data
#
# Returns:
# - The calculated average rating as an integer, or 0 if there are no ratings stored.
#
# Example:
#   store = PStore.new("tendable.pstore")
#   average_rating = calculate_average_rating(store)
#
def calculate_average_rating(store)
  total_ratings = store.transaction { store.fetch(:ratings, []) }
  if total_ratings.empty?
    0
  else
    total_ratings.sum / total_ratings.size
  end
end


# Generates a report for the current survey run, calculates ratings, stores them in the PStore, and displays the current and average ratings.
#
# Parameters:
# - store: the PStore object used for persisting data
# - answers: a hash containing the user's answers to survey questions
#
# Example:
#   store = PStore.new("tendable.pstore")
#   answers = { q1: "yes", q2: "no", q3: "yes" }
#   do_report(store, answers)
#   # => Prints the current run's rating and average rating for all runs to the console.
#
def do_report(store, answers)
  ratings = calculate_ratings(answers)
  store.transaction do
    stored_ratings = store.fetch(:ratings, [])
    stored_ratings << ratings
    store[:ratings] = stored_ratings
  end
  average_rating = calculate_average_rating(store)

  puts "Rating for this run: #{ratings}%"
  puts "Average rating for all runs: #{average_rating}%"
end

answers = do_prompt(store) # Collect user answers
store.transaction { store[:answers] = answers } # Store answers in the PStore
do_report(store, answers) # Generate and display a report based on the answers

store.transaction do
  # Accesses and displays the stored answers and ratings from the PStore within a transaction block.
  puts "Stored Answers: #{store[:answers].inspect}"
  puts "Stored Ratings: #{store.fetch(:ratings, []).inspect}"
end
