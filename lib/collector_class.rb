#encoding: utf-8
module Duck
  class Collector < Closure
    attr_accessor :closure, :contents, :target
  
    def initialize(target = INFINITY,contents_array = [])
      @contents = contents_array
      @target = target
      @closure = Proc.new do |item|
        case 
        when @contents.length + 1 > @target
          [List.new(@contents),item]
        when @contents.length + 1 == @target
          List.new(@contents << item)
        else
          Collector.new(@target,(@contents << item))
        end
      end
      @needs = ["be"]
    end
  
    def remaining
      @target-@contents.length
    end
  
    def deep_copy
      new_contents = @contents.collect {|i| i.deep_copy}
      Collector.new(@target, new_contents)
    end
  
    def to_s
      "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?"*remaining + ")"
    end
  end
end