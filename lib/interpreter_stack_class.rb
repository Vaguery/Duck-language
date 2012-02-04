#encoding: utf-8
class InterpreterStack < Assembler
  
  def push(item)
    @contents.push(item)
  end
  
  def [](where = nil)
    if where.nil?
      self.<< Closure.new(
      Proc.new do |idx| 
        index = idx.value.to_i
        how_many = self.contents.length
        which = how_many == 0 ? 0 : index % how_many
        self.contents.delete_at(which)
      end, ["inc"], "stack[?]")
    else
      @contents[where]
    end
  end
end