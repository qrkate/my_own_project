class Player
  include Bank
  include Validation
  
  NAME = /^[A-ZА-Я]{1}[a-zа-я]+$/
  
  attr_accessor :name, :hand
  validate :name, :presence
  validate :name, :format, NAME
  
  def initialize(name = "Dealler")
    @name = name
    validate!
    self.bank = 100
    @hand = Hand.new
  end
  
  def add_card
    @hand.cards.push(@hand.deck.create_card)
    @hand.calculation_score
  end
  
  def delete_cards
    @hand.cards.clear
    @hand.score = 0
  end
  
  def each_cards
    @hand.cards.each { |card| yield card } if block_given?
  end
end
