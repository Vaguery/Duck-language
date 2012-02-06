#encoding: utf-8
class Assembler < List
  # superclass has @contents
  attr_accessor :buffer
  
  
  def initialize(contents = [], buffer = [])
    @contents = contents
    @buffer = buffer
    @needs = []
  end
  
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    new_buffer = @buffer.collect {|i| i.deep_copy}
    result = self.class.new(new_contents)
    result.buffer = new_buffer
    result
  end
  
  
  def step
    staged_item = @buffer.delete_at(0)
    next_arg = index_of_next_useful_argument_for(staged_item)
    if next_arg.nil?
      wanted_by = index_of_next_item_that_wants(staged_item)
      if wanted_by.nil?
        @contents.push staged_item
      else
        curried_result = @contents.delete_at(wanted_by).grab(staged_item)
        rebuffer_intermediate_result(curried_result)
      end
    else
      curried_result = staged_item.grab(@contents.delete_at(next_arg))
      rebuffer_intermediate_result(curried_result)
    end
    self
  end
  
  def push(item)
    item.class != Array ? @buffer.push(item) : @buffer += item
    process_buffer
    self
  end
  
  
  def index_of_next_useful_argument_for(some_item)
    @contents.rindex {|arg| some_item.can_use?(arg)}
  end
  
  
  def index_of_next_item_that_wants(some_item)
    @contents.rindex {|arg| arg.can_use?(some_item)}
  end
  
  
  def rebuffer_intermediate_result(result)
    case
    when result.kind_of?(Array)
      @buffer = result + @buffer
    when result.nil?
      # do nothing
    else
      @buffer.unshift(result)
    end
  end
  
  
  def process_buffer
    until @buffer.empty?
      self.step
    end
  end
  
  def run
    self.process_buffer
    self
  end
  
  def to_s
    rep = (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ")
    rep += @contents.empty? ? "::" : " ::"
    rep += (@buffer.inject(" ") {|s,i| s+i.to_s+", "}).chomp(", ") unless @buffer.empty?
    rep += "]"
  end
  
  
  #################
  #
  #  DUCK MESSAGES
  #
  #################
  
  def +
    Closure.new(
      Proc.new do |arg|
        new_contents = @contents + arg.contents
        new_buffer = @buffer
        new_buffer += arg.buffer if arg.respond_to?(:buffer) # in case it's a List
        result = Assembler.new(new_contents)
        result.buffer = new_buffer
        result
      end,
      ["count"],
      "#{self.value} + ?"
    )
  end
  
  def count
    Int.new(@contents.length + @buffer.length)
  end
  
  def []=
    Closure.new(
      Proc.new do |idx,item|
        index = idx.value.to_i
        how_many = @contents.length + @buffer.length
        which = (how_many == 0) ? 0 : index % how_many
        
        new_assembler = self.deep_copy
        which < @contents.length ?
          new_assembler.contents[which] = item.deep_copy :
          new_assembler.buffer[which-@contents.length] = item.deep_copy
        new_assembler
      end,
      ["inc","be"],
      "(#{self.inspect}[?] = ?)"
    )
  end
  
  def rotate
    self.class.new(@contents.rotate(1), @buffer)
  end
  
  
  def []
    Closure.new(
      Proc.new do |idx| 
        index = idx.value.to_i
        how_many = @contents.length + @buffer.length
        which = how_many == 0 ? 0 : index % how_many
        unless how_many == 0
          if which < @contents.length
            self.contents[which].deep_copy
          else
            self.buffer[which-@contents.length].deep_copy
          end
        end
      end, ["inc"], "#{self.to_s}[?]")
  end
  
  
  def snap
    Closure.new(
      Proc.new do |location|
        if @contents.length > 0
          where = location.value.to_i % @contents.length
          [self.class.new(@contents[0...where],[]),self.class.new(@contents[where..-1],@buffer)]
        else
          self
        end
      end,
      ["inc"],
      "snap#{self.inspect} at ?"
    )
  end
  
  def flatten
    new_contents = @contents.inject([]) do |arr,item|
      case 
      when item.kind_of?(Assembler)
        arr + item.contents + item.buffer
      when item.kind_of?(List)
        arr + item.contents
      else
        arr << item
      end
    end
    self.class.new(new_contents, @buffer)
  end
  
  
  
  def ∩
    Closure.new(
      Proc.new do |arg|
        other_contents = arg.contents.collect {|item| item.inspect}
        other_buffer = arg.buffer.collect {|item| item.inspect} if arg.respond_to?(:buffer)
        
        Assembler.new(
          @contents.select {|element| other_contents.include? element.inspect},
          @buffer.select {|element| other_buffer.include? element.inspect})
      end,
      ["count"],
      "#{self.inspect} ∩ ?"
    )
  end
  
  def useful
    Closure.new(
      Proc.new do |item|
        results = (@contents+@buffer).group_by {|element| item.can_use?(element) ? "useful" : "unuseful"}
        [List.new(results["useful"]||[]), List.new(results["unuseful"]||[])]
      end,
      ["be"],
      "#useful({self.inspect}, ?)"
    )
  end
  
  
  def users
    Closure.new(
      Proc.new do |item|
        results = (@contents+@buffer).group_by {|element| element.can_use?(item) ? "users" : "nonusers"}
        [List.new(results["users"]||[]), List.new(results["nonusers"]||[])]
      end,
      ["be"],
      "#users({self.inspect}, ?)"
    )
  end
  
  def swap
    if @contents.length > 1
      new_contents = @contents.clone
      new_contents[-1],new_contents[-2] = @contents[-2].clone,@contents[-1].clone
      self.class.new(new_contents, @buffer)
    else
      self
    end
  end
  
  def pop # release the last item
    if @contents.empty?
      self
    else
      item = @contents.pop
      return [Assembler.new(@contents,@buffer),item]
    end
  end
  
  def unshift 
    Closure.new(Proc.new {|item| Assembler.new(@contents.clone.unshift(item.deep_copy),@buffer)},
      ["be"],"#{self.to_s}.unshift(?)")
  end
  
  def reverse
    self.class.new(@contents.reverse, @buffer)
  end
  
  def shift # release the first item
    @contents.empty? ? self :
      [self.class.new(@contents[1..-1],@buffer),@contents[0].deep_copy]
  end
  
  def ∪
    Closure.new(
      Proc.new do |other_list|
        combined_contents = other_list.contents + @contents
        combined_buffers = other_list.buffer + @buffer
        self.class.new(combined_contents.uniq {|element| element.inspect},
          combined_buffers.uniq {|element| element.inspect})
      end,
      ["count"],
      "#{self.inspect} ∪ ?"
    )
  end
  
  
  # special Assembler behaviors that differ from List:
  # :push
  # :+ (append-with-assembly)
  # :give
  # :map
  
  
  # Lists do these [:count, :[], :empty, :reverse, :copy, :swap, :pop, :shift, :unshift, :shatter, :[]=, :useful, :users, :∪, :∩, :flatten, :snap, :rewrap_by, :rotate]
  
  # keep at end of class definition!
  @recognized_messages = List.recognized_messages + [:push, :step, :run]
end