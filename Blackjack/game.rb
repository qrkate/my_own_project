require_relative "bank.rb"
require_relative "players.rb"
require_relative "deck.rb"

module Game
  MENU3 = "Пропустить ход - 0 \nОткрыть карты - 1 \nДобавить карту - 2"
  MENU2 = "Пропустить ход - 0 \nОткрыть карты - 1"
  attr_accessor :user, :dealler, :deck, :move

  def create
    puts "Введите ваше имя:"
    @user = Players.new(gets.chomp)
    @dealler = Players.new
    self.bank = 0
    @deck = Deck.new
  rescue => e
    puts e.message
    retry
  end
  
  def deal
    x = 0
    while x < 2
      @dealler.add_card(@deck.create_card)
      @user.add_card(@deck.create_card)
      x += 1
    end
    @dealler.calculation_score
    @user.calculation_score
    @move = 1
  end
  
  def show_players_head(value = false)
    secret_dealler_head if value == false
    dealler_head if value == true
    user_head
  end
  
  def user_head
    puts "Ваши карты:"
    @user.each_cards { |card| puts "#{card.values.first}#{card.keys.first}" }
    puts "Ваш счет: #{@user.score}"
  end
  
  def secret_dealler_head
    puts "Карты противника:"
    @dealler.each_cards { |card| puts "#{card.values.first}#{card.keys.first}".gsub(/(......|.....|....|...|..|.)/, '*') }
    puts "Счет противника: " + "#{@dealler.score}".gsub(/(..|.)/, '*')
  end
  
  def dealler_head
    puts "Карты противника:"
    @dealler.each_cards { |card| puts "#{card.values.first}#{card.keys.first}" }
    puts "Счет противника: " + "#{@dealler.score}"
  end
  
  def bet
    @user.give_money(self, 10)
    @dealler.give_money(self, 10)
    puts "Начальная ставка 10$. \nСтавки сделаны. \nВ банке #{self.bank}$."
  end
  
  def make_move
    return if (@user.cards.length && @dealler.cards.length) == 3
    user_move if @move % 2 != 0
    dealler_move if @move % 2 == 0
  end
  
  def user_move
    puts "Ваш ход:"
    puts MENU3 if @user.cards.length < 3
    puts MENU2 if @user.cards.length == 3
    case gets.chomp.to_i
    when 0
      skip
    when 1
      return
    when 2
      hit_me(@user)
    end
  end
  
  def dealler_move
    puts "Ход диллера!"
    skip if @dealler.score >= 17
    hit_me(@dealler) if @dealler.score < 17
  end
  
  def skip
    puts "Пропуск хода!"
    @move += 1
    make_move
  end
  
  def hit_me(player)
    puts "#{player.name} добавил_а карту!"
    player.add_card(@deck.create_card)
    player.calculation_score
    show_players_head
    @move += 1
    make_move
  end
  
  def open_card
    puts "Открываем карты!"
    show_players_head(true)
  end
  
  def result
    show_winner(@user) if user_win?
    show_winner(@dealler) if dealler_win?
    dead_heat if @dealler.score == @user.score
  end
  
  def user_win?
    @user.score > @dealler.score && @user.score <= 21 || @dealler.score > 21 && @user.score <= 21
  end
  
  def dealler_win?
    @dealler.score > @user.score && @dealler.score <= 21 || @user.score > 21 && @dealler.score <= 21
  end
  
  def show_winner(player)
    puts "В этой партии победил_а #{player.name}! Выигрыш в размере #{@bank}$ перечислен в банк #{player.name}."
    self.give_money(player, @bank)
  end
  
  def dead_heat
    puts "Ничья! Ставки в размере 10$ перечислены обратно в банки игроков."
    bet = 10
    self.give_money(@user, bet)
    self.give_money(@dealler, bet)
  end
  
  def continue
    puts "Хотите продолжить? \nНет - 0 \nДа - 1"
    case gets.chomp.to_i
    when 0
      exit
    when 1
      @user.delete_cards
      @dealler.delete_cards
    end
  end
  
  def validate_bank
    puts "Банк #{@user.name}: #{@user.bank} \nБанк #{@dealler.name}: #{@dealler.bank}"
    if (@user.bank || @dealler.bank) == 0
      puts "В этой игре победил_а #{@user.name}" if @dealler.bank == 0
      puts "В этой игре победил_а #{@dealler.name}" if @user.bank == 0
    else
      continue
    end
   end
end
