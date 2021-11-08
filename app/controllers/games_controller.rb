require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params['word']
    @letters = params[:letters]
    @authenticity_token = params['authenticity_token']
    # raise
    dictionary = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read)

    if dictionary["found"] && letter_check(@word, @letters)
      @result = "#{@word.upcase} is a valid English word!"
    elsif dictionary["found"] && letter_check(@word, @letters) == false
      @result = "Sorry but #{@word.upcase} can't be built out of #{@letters}"
    else
      @result = "Sorry but #{@word.upcase} doesn't seem to be a valid English word."
    end
  end

  def letter_check(attempt, grid)
    attempt.chars.all? do |letter|
      attempt.upcase.chars.count(letter.upcase) <= grid.count(letter.upcase)
    end
  end
end
