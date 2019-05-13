require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:user_word]
    @grid = params[:letters].split(' ')
    @answer = message(@word, @grid)
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        return "Congratulations! #{@word} is valid English word!"
      else
        return "Sorry, but #{@word} does not seem to be a valid English word"
      end
    else
      return "Sorry, but #{@word} can't be built out of #{@grid.join(", ")}"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
