class Hand
  attr_accessor :cards, :score, :deck
  
  def initialize
    @deck = Deck.new
    @cards = []
    @score = 0
  end
  
  def calculation_score
    @score = 0
    @cards.each do |card|
      case card.values.first
      when Integer
        @score += card.values.first
      when String
        @score += 10
      when Symbol
        if @score > 10
          @score += 1
        else
          @score += 11
        end
      end
    end
  end
end
