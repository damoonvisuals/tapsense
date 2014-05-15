#!/usr/bin/env ruby

# Data structure used for holding the dictionary of words
require 'trie'

# Adds functionality to string to check for integer
class String
  def is_i?
     !!(self =~ /^[-+]?[0-9]+$/)
  end
end

class OptimalGhost
  @@MIN_WORD_LENGTH = 4

  def initialize
    @t = Trie.new
  end

  def construct_dictionary
    puts "Constructing dictionary.."

    File.open("WORD.LST.txt").each_line do |word|
      wrd = word.chomp # Chops the new line character
      @t.add wrd if wrd.length >= @@MIN_WORD_LENGTH
    end
  end

  # Optimally chooses next letter in the game.  Initially choose letter in word of odd length that will increase chances of winning.  Otherwise choose word of even length with maximal length.
  def computer_letter_choice(current_word, turn_number)
    puts "Computer is thinking..."

    win_words = @t.children(current_word)
    odd_length_words = []
    even_length_words = []

    # Go through all winning words and separate into odd and even length strings
    win_words.each do |word|
      if word.length % 2 == 0
        even_length_words << word
      else
        odd_length_words << word
      end
    end

    even_length_words = even_length_words.sort_by(&:length) # Sort even length words by length

    optimal_word = ''
    if odd_length_words.length > 0 # Winning word/strategy exists, choose randomly from
      optimal_word = odd_length_words.sample

      # Debugging output
      # puts "Computer chose word #{optimal_word}"
    elsif even_length_words.length > 0 # No winning word exists, stall
      optimal_word = even_length_words[-1] # Select last element of even length words (invariance guarantees longest string)
    else # No words left to choose from, admit defeat
      optimal_word = "a"
    end

    next_letter = (optimal_word.length > 1 ? optimal_word[turn_number] : optimal_word[0])

    return next_letter
  end

  # Starts the Optimal Ghost game
  def start_game
    whose_turn = 'Player'
    current_word = ''
    turn_number = 0

    puts "~~~ Welcome to Ghost ~~~"

    while true do
      if whose_turn == 'Player'
        print "Please enter a letter: "
        next_letter = gets.chomp.to_s.downcase[0] # Selects first letter, lowercase of any string

        current_word = current_word + next_letter
      else # Computer's turn
        next_letter = self.computer_letter_choice(current_word, turn_number)
        puts "Computer chooses letter: #{next_letter}"
        current_word = current_word + next_letter
      end

      puts "Current string: \"#{current_word}\""

      # Check for valid word, if it is -- game over
      if @t.has_key?(current_word)
        puts "~~~ Game Over. ~~~"
        puts "~~~ #{whose_turn} loses. ~~~"
        puts "~~~ Completed word: #{current_word} ~~~"
        break
      end

      # Check for invalid word, or if player/computer cannot advance
      if @t.children(current_word).length == 0
        puts "~~~ Game Over. ~~~"
        puts "~~~ #{whose_turn} loses. ~~~"
        puts "~~~ Invalid word/Cannot advance: #{current_word}... ~~~"
        break
      end

      turn_number += 1
      whose_turn = (whose_turn == 'Player' ? "Computer" : "Player")
    end

  end
end

# Main
opt_ghost = OptimalGhost.new
opt_ghost.construct_dictionary

while true do
  opt_ghost.start_game
  print "Would you like to quit the game [y|n]?: "
  option = gets.chomp.to_s.downcase[0]

  if option == 'y'
    break
  elsif option == 'n'
    next
  else
    puts "Invalid option.. Play again"
  end

end
# Debugging output
# if t.has_key?("aa")
#   puts "true"
# end