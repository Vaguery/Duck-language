#encoding: utf-8
class Assembler < List
  # superclass has @contents
  attr_accessor :buffer
  
  
  def initialize(*items)
    @contents = items
    @buffer = []
    @needs = []
  end
  
  
  def <<(item)
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
  
  
  def to_s
    (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ") + "]"
  end
  
  
  # special Assembler behaviors that differ from List:
  # :<< (push)
  # :+ (append-with-assembly)
  # :give
  # :map
  
  
  # Lists do these [:count, :[], :empty, :reverse, :copy, :swap, :pop, :shift, :>>, :shatter, :[]=, :useful, :users, :∪, :∩, :flatten, :snap, :rewrap_by, :rotate]
  
  # keep at end of class definition!
  @recognized_messages = List.recognized_messages + [:<<]
end