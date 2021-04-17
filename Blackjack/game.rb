class Game
  include Bank
  attr_accessor :user, :dealler

  def initialize
    self.bank = 0
  end
  
  def create(name)
    @user = Player.new(name)
    @dealler = Player.new
  end
  
  def deal
    x = 0
    while x < 2
      @dealler.add_card
      @user.add_card
      x += 1
    end
  end
  
  def bet
    @user.give_money(self, 10)
    @dealler.give_money(self, 10)
  end
  
  def valid_cards
    (@user.hand.cards.length && @dealler.hand.cards.length) == 3
  end
  
  def dealler_move
    return if @dealler.hand.score >= 17
    hit_me_dealler if @dealler.hand.score < 17
  end
  
  def hit_me_dealler
    @dealler.add_card
  end
  
  def hit_me_user
    @user.add_card
  end
  
  def user_win?
    @user.hand.score > @dealler.hand.score && @user.hand.score <= 21 || @dealler.hand.score > 21 && @user.hand.score <= 21
  end
  
  def dealler_win?
    @dealler.hand.score > @user.hand.score && @dealler.hand.score <= 21 || @user.hand.score > 21 && @dealler.hand.score <= 21
  end
  
  def user_win!
    self.give_money(@user, @bank)
  end
  
  def dealler_win!
    self.give_money(@dealler, @bank)
  end
  
  def dead_heat
    bet = 10
    self.give_money(@user, bet)
    self.give_money(@dealler, bet)
  end
  
  def set_zero_hand
    @user.delete_cards
    @dealler.delete_cards
  end
  
  def user_score
    @user.hand.score
  end
  
  def dealler_score
    @dealler.hand.score
  end
  
  def user_how_cards?
    @user.hand.cards.length
  end
  
  def dealler_how_cards?
    @dealler.hand.cards.length
  end
end
