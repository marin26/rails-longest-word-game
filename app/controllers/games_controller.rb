require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    run_game(params[:word], params[:array], Time.parse(params[:start_time]).to_i, Time.now.to_i)
  end

  def length(attempt)
    attempt.length.to_i
  end

  def time(start_time, end_time)
    ti = end_time - start_time
    1.0 / ti
  end

  def letters(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def dico(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user["found"]
  end

  def run_game(attempt, grid, start_time, end_time)
   # TODO: runs the game and return detailed hash of result
    if letters(attempt.upcase, grid) && dico(attempt)
      score = length(attempt) + time(start_time, end_time)
      @score = score
      @message = "well done"
    elsif !letters(attempt.upcase, grid)
      @score = 0
      @message = "not in the grid"
    elsif !dico(attempt)
      @score = 0
      @message = "not an english word"
    end
  end
end
