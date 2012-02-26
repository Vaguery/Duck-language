#encoding: utf-8

module Duck
  class Iterator < List
    attr_accessor :start, :end
    attr_accessor :inc
    attr_accessor :actual_inc
    attr_accessor :index
    attr_accessor :contents
    attr_accessor :min_value, :max_value
    attr_accessor :response
    
    def initialize(args = {})
      default_args = {start:0, end:0, inc:1, index:nil}
      args = default_args.merge(args)
      @start = args[:start]
      @end = args[:end]
      @inc = args[:inc]
      @actual_inc =
        if (@start > @end && @inc > 0) || (@start < @end && @inc < 0)
          -@inc
        else
          @inc
        end 
      @index = args[:index] || @start
      @contents = args[:contents] || []
      @response = args[:response] || :contents
      @min_value,@max_value = [@start,@end].minmax
      @needs = []
    end
    
    
    def deep_copy
      Iterator.new(
        start:@start,
        end:@end,
        inc:@inc,
        index:@index,
        contents:@contents.collect {|item| item.deep_copy},
        response:@response,
      )
    end
    
    
    def to_s
      rounded_index = @index.kind_of?(Float) ? "~(#{@index.round(3)})" : "#{@index}"
      return "(#{@start}..#{rounded_index}..#{@end})=>#{@contents}"
    end
    
    
    def index_in_range?
      @start < @end ?
      @min_value <= @index && @index < @max_value :
      @min_value < @index && @index <= @max_value 
    end
    
    
    def reset_index_within_range
      if !index_in_range?
        @index = @min_value if @index < @min_value
        @index = @max_value if @index >= @max_value
      end
    end
    
    
    def output_value
      case @response
      when :element
        output =  @contents.empty? ? [] : [@contents[@index % @contents.length].deep_copy]
      when :index
        output = @index.kind_of?(Float) ? [Decimal.new(@index)] : [Int.new(@index)]
      else
        output = @contents.collect {|item| item.deep_copy}
      end
      return output
    end
    
    
    # DUCK HANDLERS
    
    
    duck_handle :∪ do
      Closure.new(["shatter"], "#{self.inspect} ∪ ?") do |listy_thing|
        result_iterator = self.deep_copy
        aggregated = listy_thing.contents + result_iterator.contents
        unionized = aggregated.uniq {|element| element.inspect}
        result_iterator.contents = unionized
        result_iterator
      end
    end
    
    
    duck_handle :again do
      if index_in_range?
        output_array = self.output_value
        output_array.unshift(self)
      else
        reset_index_within_range
        self
      end
    end
    
    
    duck_handle :index= do
      Closure.new(["neg"], "#{self.inspect}.index=?") do |int|
        @index = int.value
        self
      end
    end
    
    
    duck_handle :rewrap_by do
      Closure.new(["inc"],"rewrap#{self.inspect} by ?") do |size|
        slice_size = size.value.to_i
        slice_size = @contents.length if slice_size < 1
        if @contents.empty?
          result = self
        else
          result = @contents.each_slice(slice_size).collect do |chunk|
            new_boy = self.deep_copy
            new_boy.contents = chunk
            new_boy
          end
        end
        result
      end
    end
    
    
    duck_handle :run do
      if index_in_range?
        self.step << message("run")
      else
        reset_index_within_range
        self
      end
    end
    
    
    duck_handle :shatter do
      @contents.unshift Span.new(@start, @end)
    end
    
    
    duck_handle :size do
      count = (@contents).inject(1) {|sum,item| sum + item.size[1].value}
      count += 1 # to count the Span
      [self, Int.new(count)]
    end
    
    
    
    duck_handle :snap do
      Closure.new(["inc"],"snap#{self.inspect} at ?") do |location|
        if @contents.length > 0
          where = location.value.to_i % @contents.length
          clone = self.deep_copy
          clone.contents = @contents[where..-1]
          @contents = @contents[0...where]
          [self,clone]
        else
          self
        end
      end
    end
    
    
    
    
    duck_handle :step do
      if index_in_range?
        output_array = self.output_value
        @index += @actual_inc
        output_array.unshift(self)
      else
        reset_index_within_range
        self
      end
    end
    
    
    duck_handle :to_assembler do
      Assembler.new(contents:[self])
    end
    
    
    duck_handle :to_binder do
      Binder.new([self])
    end
    
    
    duck_handle :to_interpreter do
      Interpreter.new(contents:[self])
    end
    
    
    duck_handle :to_list do
      List.new(@contents.unshift Span.new(@start, @end))
    end
    
    
    duck_handle :to_span do
      Span.new(@start, @end)
    end
    
    
  end
end