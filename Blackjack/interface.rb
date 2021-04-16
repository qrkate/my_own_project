require_relative "game.rb"
require_relative "bank.rb"
require_relative "players.rb"
require_relative "deck.rb"

class Interface
  include Game
  include Bank
  
  def start
    create
    loop do
      deal
      show_players_head
      bet
      make_move
      open_card
      result
      validate_bank
    end
  end
end
    
Interface.new.start
