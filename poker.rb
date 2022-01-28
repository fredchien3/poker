class Card
    attr_reader :importance, :suit, :face, :color

    def initialize(importance, suit)
        @importance = importance  # integer
        @suit = suit # a symbol
        # face is a string
        self.set_face
        self.set_color
    end

    def set_face
        case @importance
        when 13
            @face = "A"
        when 12
            @face = "K"
        when 11
            @face = "Q"
        when 10
            @face = "J"
        else 
            @face = (importance + 1).to_s
        end
    end

    def set_color
        case @suit
        when :spade, :club
            @color = :black
        when :heart, :diamond
            @color = :red
        end
    end

    def inspect
        {@face => @suit}.inspect
    end
end

class Deck
    SUITS = %i(spade heart club diamond)

    attr_reader :deck

    def initialize
        @deck = Array.new
        (1..13).each do |importance|
            SUITS.each do |suit|
                @deck << Card.new(importance, suit)
            end
        end
        true
    end
end

class Hand