require 'yaml'
require_relative 'Game'
require 'byebug'
class Main
  def initialize
    @game = nil
  end

  def read_from_file(file_name); end

  def start
    loop do
      handle_user_input(user_input_prompt)
    end
  end

  def handle_user_input(user_input)
    case user_input
    when 's'
      save_game
    when 'p'
      play_new_game
    when 'c'

    else
      puts 'Wrong input. Please try again'
    end
  end

  def save_game
    debugger
    if not @game.finished && not @game == nil
      puts 'Give a save file name'
      file_name = gets.chomp
      File.open("./save_files/#{file_name}", 'w') { |file| file.write(@game.to_yaml) }
      next
    end
    puts "Can't save a finished game or a non existing game"
  end

  def play_new_game
    @game = Game.new
    @game.play
  end

  def continue_existing_game
    saved_files = Dir.entries('./save_files')
    puts 'Give saved file name'
    saved_files.each { |file_name| puts file_name }
    @game = YAML.load_file("./save_files/#{gets.chomp}")
    @game.play
  end

  def user_input_prompt
    puts 'choose an option'
    puts 's -> save game'
    puts 'p -> play new game'
    puts 'c -> continue existing game if exists'
    gets.chomp
  end
end
