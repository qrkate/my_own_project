require_relative "bank.rb"
require_relative "validation.rb"
require_relative "players.rb"
require_relative "deck.rb"
require_relative "hand.rb"
require_relative "game.rb"

class Interface
  def initialize
    puts "Добро пожаловать в игру!"
    @game = Game.new
  end
  
  def start_game
    puts "Введите ваше имя:"
    @game.create(gets.chomp)
    loop do
      @game.deal
      @game.bet
      show_bet
      show_players_hand
      user_move
      if @game.user_win?
        end_game('user')
      elsif @game.dealler_win?
        end_game('dealler')
      else
        end_game
      end
    end
  rescue => e
    puts e.message
    retry
  end
  
  private
  MENU3 = "Пропустить ход - 0 \nОткрыть карты - 1 \nДобавить карту - 2"
  MENU2 = "Пропустить ход - 0 \nОткрыть карты - 1"
  
  def show_players_hand(value = false)
    secret_dealler_hand if value == false
    dealler_hand if value == true
    user_hand
  end
  
  def user_hand
    puts "Ваши карты:"
    @game.user.each_cards { |card| puts "#{card.values.first}#{card.keys.first}" }
    puts "Ваш счет: #{@game.user_score}"
  end
  
  def dealler_hand
    puts "Карты противника:"
    @game.dealler.each_cards { |card| puts "#{card.values.first}#{card.keys.first}" }
    puts "Счет противника: " + "#{@game.dealler_score}"
  end
  
  def secret_dealler_hand
    puts "Карты противника:"
    @game.dealler.each_cards { |card| puts "#{card.values.first}#{card.keys.first}".gsub(/(......|.....|....|...|..|.)/, '*') }
    puts "Счет противника: " + "#{@game.dealler_score}".gsub(/(..|.)/, '*')
  end
  
  def show_bet
    puts "Начальная ставка 10$. \nСтавки сделаны. \nВ банке #{@game.bank}$."
  end
  
  def user_move
    puts "Ваш ход:"
    puts MENU3 if @game.user_how_cards? < 3
    puts MENU2 if @game.user_how_cards? == 3
    case gets.chomp.to_i
    when 0
      puts "Ход переходит противнику"
      @game.valid_cards ? open_card : dealler_move
    when 1
      open_card
    when 2
      @game.hit_me_user
      puts "Вам добавлена карта!"
      user_hand
      @game.valid_cards ? open_card : dealler_move
    end
  end
  
  def dealler_move
    dealler_hand = @game.dealler_how_cards?
    @game.dealler_move
    if @game.dealler_how_cards? > dealler_hand
      puts "Противник добавил карту"
      secret_dealler_hand
    else
      puts "Противник пропустил ход."
    end
    @game.valid_cards ? open_card : user_move
  end
  
  def open_card
    puts "Вскрываемся:"
    show_players_hand(true)
  end
  
  def end_game(player = "dead_heat")
    case player
    when "dead_heat"
      @game.dead_heat
      puts "Ничья! Ставки в размере 10$ перечислены обратно в банки игроков."
    when 'user'
    puts "В этой партии победил_а #{@game.user.name}! Выигрыш в размере #{@game.bank}$ перечислен в банк #{@game.user.name}."
      @game.user_win!
    when 'dealler'
      puts "В этой партии победил_а #{@game.dealler.name}! Выигрыш в размере #{@game.bank}$ перечислен в банк #{@game.dealler.name}."
      @game.dealler_win!
    end
    validate_bank
  end
  
  def validate_bank
    puts "Банк #{@game.user.name}: #{@game.user.bank} \nБанк #{@game.dealler.name}: #{@game.dealler.bank}"
    if (@game.user.bank || @game.dealler.bank) == 0
      puts "В этой игре победил_а #{@game.user.name}" if @game.dealler.bank == 0
      puts "В этой игре победил_а #{@game.dealler.name}" if @game.user.bank == 0
    else
      continue
    end
   end
  
  def continue
    puts "Хотите продолжить? \nНет - 0 \nДа - 1"
    gets.chomp == '1' ? @game.set_zero_hand : exit
  end
end
    
Interface.new.start_game
