require_relative 'card.rb'

class Deck
    SUITS = %i(spade heart club diamond)

    attr_accessor :deck

    def initialize
        @deck = Array.new
        (1..13).each do |importance|
            SUITS.each do |suit|
                @deck << Card.new(importance, suit)
            end
        end
        @deck.shuffle!
        true
    end

    def display
        @deck.each do |card|
            card.render
            puts " "
        end
        true
    end

end