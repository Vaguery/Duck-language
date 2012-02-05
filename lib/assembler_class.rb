#encoding: utf-8
class Assembler < List
  # superclass has @contents
  attr_accessor :buffer
  
  
  def initialize(*items)
    @contents = items
    @buffer = []
    @needs = []
  end
  
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    new_buffer = @buffer.collect {|i| i.deep_copy}
    result = self.class.new(*new_contents)
    result.buffer = new_buffer
    result
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
      staged_item = @buffer.delete_at(0)
      next_arg = index_of_next_useful_argument_for(staged_item)
      if next_arg.nil?
        # self.be_consumed(staged_item) if staged_item.can_use?(self)
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
    end
  end
  
  
  def +
    Closure.new(
      Proc.new do |arg|
        new_contents = @contents + arg.contents
        new_buffer = @buffer
        new_buffer += arg.buffer if arg.respond_to?(:buffer) # in case it's a List
        result = Assembler.new(*new_contents)
        result.buffer = new_buffer
        result
      end,
      ["count"],
      "#{self.value} + ?"
    )
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
  
  
  
  def to_s
    rep = (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ") + " ::"
    rep += (@buffer.inject(" ") {|s,i| s+i.to_s+", "}).chomp(", ") unless @buffer.empty?
    rep += "]"
  end
  
  
  # special Assembler behaviors that differ from List:
  # :push
  # :+ (append-with-assembly)
  # :give
  # :map
  
  
  # Lists do these [:count, :[], :empty, :reverse, :copy, :swap, :pop, :shift, :unshift, :shatter, :[]=, :useful, :users, :∪, :∩, :flatten, :snap, :rewrap_by, :rotate]
  
  # keep at end of class definition!
  @recognized_messages = List.recognized_messages + [:push]
end