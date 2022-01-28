require_relative 'deck.rb'

class Hand
    attr_accessor :hand

    def initialize(the_deck=Deck.new)
        @hand = Array.new
        @the_deck = the_deck
        true
    end
    
    def draw_from_deck
        5.times { @hand << @the_deck.deck.pop }
    end

    def rank # evaluate the rank of current hand.
        self.sort!
        return 9 if self.straight_flush?
        return 8 if self.four_of_a_kind?
        return 7 if self.full_house?
        return 6 if self.flush?
        return 5 if self.straight?
        return 4 if self.three_of_a_kind?
        return 3 if self.two_pair?
        return 2 if self.one_pair?
        return 1 if self.high_card?
        # can implement a rank array as a tiebreaker. or some other solution.
    end

    def sort! # sorts by importance, starting with most important
        @hand.sort_by! { |card| -card.importance }
    end
    
    # ---helper methods below---

    def all_same_suit?
        @hand.uniq { |card| card.suit }.length == 1
    end

    def sequential_rank?
        arr = Array.new # array of cards' importance, from high to low
        @hand.each do |card|
            arr << card.importance
        end
        arr.each_cons(2).all? { |a, b| a-1 == b }
    end

    def count_kinds # kinds i.e. importances
        count = Hash.new(0)
        @hand.each { |card| count[card.importance] += 1 }
        return count
    end

    # ---checker methods below---
    # assume hand is sort!ed (high to low importance)


    def straight_flush? # all same suit and sequential rank
        self.all_same_suit? && self.sequential_rank?
    end
    
    def four_of_a_kind? # four of one importance, one of another
        count = self.count_kinds
        count.length == 2 && count.has_value?(4) && count.has_value?(1)
    end

    def full_house? # three of one importance, two of another
        count = self.count_kinds
        count.length == 2 && count.has_value?(3) && count.has_value?(2)
    end

    def flush? # all same suit, whatever rank
        self.all_same_suit? && !self.sequential_rank?
    end

    def straight? # whatever suit, sequential rank
        !self.all_same_suit? && self.sequential_rank?
    end

    def three_of_a_kind? # three of one importance, another, and another
        count = self.count_kinds
        count.length == 3 && count.has_value?(3) && count.has_value?(1)
    end

    def two_pair? # two of one importance, two of another, one of another
        count = self.count_kinds
        count.length == 3 && count.has_value?(2) && count.has_value?(1)
    end

    def one_pair? # two of one importance, three of three others
        count = self.count_kinds
        count.length == 4 && count.has_value?(2) && count.has_value?(1)
        # other two checks are probably redundant
    end

    def high_card? # aka no pair aka nothing
        true # doesn't fall into any other category
    end

end