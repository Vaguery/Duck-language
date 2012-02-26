#encoding: utf-8

module Duck
  class Span < Item
    attr_accessor :start_value, :end_value
    
    def initialize(start_value, end_value)
      @start_value = start_value
      @end_value = end_value
      @needs = []
    end
    
    def deep_copy
      Span.new(@start_value, @end_value)
    end
    
    
    def to_s
      "(#{@start_value}..#{@end_value})"
    end
    
    # DUCK MESSAGES
    
    duck_handle :∪ do
      Closure.new(["cover?"], "#{self.inspect} ∪ ?") do |other_span|
        termini = [@start_value,@end_value, other_span.start_value, other_span.end_value]
        if termini.detect {|number| number.kind_of?(Float)}
          termini = termini.collect {|item| item.to_f}
        end
        Span.new(termini.min, termini.max)
      end
    end
    
    
    duck_handle :cover? do
      Closure.new(["cover?"], "#{self.inspect}.cover?(?)") do |other_span|
        sorted = [@start_value,@end_value].sort
        rubified_range = (sorted[0]..sorted[1])
        bool(rubified_range.cover?(other_span.start_value) && rubified_range.cover?(other_span.end_value))
      end
    end
    
    
    duck_handle :include? do
      Closure.new(["neg"], "#{self.inspect}.include?(?)") do |num|
        sorted = [@start_value,@end_value].sort
        rubified_range = (sorted[0]..sorted[1])
        Bool.new(rubified_range.cover? num.value)
      end
    end
    
    
    duck_handle :size do
      [self, Int.new(2)]
    end
    
  end
end