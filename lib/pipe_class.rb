#encoding: utf-8
module Duck
  class Pipe < Closure
    attr_accessor :closure, :contents
  
    def initialize(item_array=[])
      @contents = item_array
      @closure = Proc.new {|item| item.value == "(".intern ?
        List.new(@contents) : Pipe.new(@contents.unshift(item.deep_copy))}
      @needs = ["be"]
    end
  
    def deep_copy
      new_contents = @contents.collect {|i| i.deep_copy}
      Pipe.new(new_contents)
    end
  
    define_method( "(".intern ) {List.new(@contents)}
  
    def to_s
      "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?) )"
    end
    
    # DUCK MESSAGES
    
    duck_handle :size do
      count = (@contents).inject(1) {|sum,item| sum + item.size[1].value}
      [self, Int.new(count)]
    end
    
  end
end