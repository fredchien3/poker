class Card
    attr_reader :importance, :suit, :face, :color

    def initialize(importance, suit)
        @importance = importance  # integer
        # a card's rank will be referred to as its importance
        # to avoid personal confusion over say 'leaderboard' rank vs 'company' rank
        # i.e. is higher rank better? or is lower rank better? 
        @suit = suit # a symbol
        self.set_face # string
        self.set_color # symbol
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