class Deck
  attr_reader :card

  @@hearts = "\u2665"
  @@clubs = "\u2663"
  @@diamonds = "\u2666"
  @@spades = "\u2660"
    
  SUIT = [@@hearts.encode('utf-8'), @@clubs.encode('utf-8'), @@diamonds.encode('utf-8'), @@spades.encode('utf-8')]
  RANK = [:Ace, "King", "Queen", "Jack", 10, 9, 8, 7, 6, 5, 4, 3, 2]

  def create_card
    @card = {SUIT.sample => RANK.sample}
  end
end
