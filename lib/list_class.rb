#encoding:utf-8

def list(contents=[])
  List.new(contents)
end

module Duck
  class List < Item
    attr_accessor :contents
  
    def initialize(contents=[])
      @contents = contents
      @needs = []
    end
  
    def deep_copy
      new_contents = @contents.collect {|i| i.deep_copy}
      self.class.new(new_contents)
    end
  
  
    def to_s
      (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ")"
    end
  
    # DUCK METHODS
  
    duck_handle :[] do
      Closure.new(["inc"], "#{self.to_s}[?]") do |idx| 
        index = idx.value.to_i
        how_many = self.contents.length
        which = how_many == 0 ? 0 : index % how_many
        self.contents[which].deep_copy unless how_many == 0
      end
    end
    
    
    duck_handle :[]= do
      Closure.new(['inc'], "(#{self.inspect}[?2] = ?1)") do |index|
        Closure.new(['be'],"(#{self.inspect}[#{index}] = ?1)") do |new_item|
          results = @contents.collect {|i| i.deep_copy}
          idx = index.value.to_i
          which = (results.length == 0) ? 0 : (idx % results.length)
          results[which] = new_item.deep_copy
          List.new(results)
        end
      end 
    end
  
  
    duck_handle :+ do
      Closure.new(["shatter"],"#{self.to_s}+(?)") {|other_list| List.new(other_list.contents + @contents)}
    end
  
  
    duck_handle :∪ do
      Closure.new(["shatter"],"#{self.inspect} ∪ ?") do |other_list|
        aggregated = other_list.contents + @contents
        self.class.new(aggregated.uniq {|element| element.inspect})
      end
    end
  
  
    duck_handle :∩ do
      Closure.new(["shatter"],"#{self.inspect} ∩ ?") do |other_list|
        overlappers = other_list.contents.collect {|item| item.inspect}
        @contents = @contents.select {|element| overlappers.include? element.inspect}
        self
      end
    end
  
  
    duck_handle :copy do
      @contents << @contents[-1].deep_copy unless @contents.empty?
      self
    end
  
  
    duck_handle :empty do
      @contents = []
      self
    end
    
    
    duck_handle :emit do
      Closure.new(["do"], "#{self.inspect}.emit(?)") do |msg|
        reply = @contents.rindex {|item| item.recognize_message?(msg.value)}
        if reply.nil?
          self
        else
          item = @contents.delete_at(reply)
          [self, item]
        end
      end
    end
    
    
    duck_handle :flatten do
      new_contents = @contents.inject([]) do |arr,item|
        item.kind_of?(List) ?
        arr + item.contents :
        arr << item
      end
      @contents = new_contents
      self
    end
    
    
    duck_handle :fold_up do
      @contents.inject do |memo, item|
        case
          when memo.nil?
            item
          when memo.kind_of?(Array)
            memo.collect {|branch| branch.grab(item)}.flatten.compact
          else
            memo.grab(item)
          end
      end
    end
    
    
    duck_handle :fold_down do
      @contents.reverse.inject do |memo, item|
        case
          when memo.nil?
            item
          when memo.kind_of?(Array)
            memo.collect {|branch| branch.grab(item)}.flatten.compact
          else
            memo.grab(item)
          end
      end
    end
    
    
    duck_handle :give do
      Closure.new(["be"],"give(#{self.inspect}, ?)") do |item|
        results = @contents.collect {|i| i.grab(item.deep_copy)}.flatten.compact
        size = results.inject("") {|rep,i| rep+(i.to_s)}.length
        size < @@result_size_limit ? List.new(results) : Error.new("OVERSIZE")
      end
    end
    
    
    duck_handle :infold_down do
      @contents.reverse.inject do |memo, item|
        case
          when memo.nil?
            item
          when memo.kind_of?(Array)
            memo.collect {|branch| item.grab(branch)}.flatten.compact
          else
            item.grab(memo)
          end
      end
    end
    
    
    duck_handle :infold_up do
      @contents.inject do |memo, item|
        case
          when memo.nil?
            item
          when memo.kind_of?(Array)
            memo.collect {|branch| item.grab(branch)}.flatten.compact
          else
            item.grab(memo)
          end
      end
    end
    
    
    duck_handle :length do
      Int.new(@contents.length)
    end
    
    
    duck_handle :map do
      Closure.new(["be"],"map(#{self.inspect}, ?)") do |item|
        new_contents = @contents.collect {|i| i.deep_copy}
        results = new_contents.collect {|i| item.deep_copy.grab(i.deep_copy)}.flatten.compact
        size = results.inject("") {|rep,i| rep + (i.to_s)}.length
        size < @@result_size_limit ? List.new(results) : Error.new("OVERSIZE")
      end
    end
    
    
    duck_handle :pop do
      if @contents.empty?
        self
      else
        released_item = @contents.pop
        [self,released_item]
      end
    end
  
  
    duck_handle :push do
      Closure.new(["be"],"#{self.to_s}.push(?)") do |item|
        @contents << item
        self
      end
    end
  
  
    duck_handle :reverse do
      @contents = @contents.reverse
      self
    end
  
  
    duck_handle :rewrap_by do
      Closure.new(["inc"], "rewrap#{self.inspect} by ?") do |size|
        slice_size = size.value.to_i
        slice_size = @contents.length if slice_size < 1
        @contents.empty? ?
          self :
          @contents.each_slice(slice_size).collect {|chunk| self.class.new(chunk)}
      end
    end
  
  
    duck_handle :rotate do
      self.class.new(@contents.rotate(1))
    end
  
  
    duck_handle :shatter do
      @contents
    end
  
  
    duck_handle :shift do
      if @contents.empty?
        self
      else
        released_item = @contents.delete_at(0)
        [self,released_item]
      end
    end
  
  
    duck_handle :snap do
      Closure.new(["inc"],"snap#{self.inspect} at ?") do |location|
        if @contents.length > 0
          where = location.value.to_i % @contents.length
          [self.class.new(@contents[0...where]),self.class.new(@contents[where..-1])]
        else
          self
        end
      end
    end
  
  
    duck_handle :swap do
      @contents[-1],@contents[-2] = @contents[-2].clone,@contents[-1].clone if @contents.length > 1
      self
    end
  
  
    duck_handle :unshift do
      Closure.new(["be"],"#{self.to_s}.unshift(?)") do |item|
        @contents.unshift item.deep_copy
        self
      end
    end
  
  
    duck_handle :useful do
      Closure.new(["be"],"#useful(#{self.inspect}, ?)") do |item|
        results = @contents.group_by {|element| item.can_use?(element) ? "useful" : "unuseful"}
        [self.class.new(results["useful"]||[]), self.class.new(results["unuseful"]||[])]
      end
    end
  
  
    duck_handle :users do
      Closure.new(["be"],"#users({self.inspect}, ?)") do |item|
        results = @contents.group_by {|element| element.can_use?(item) ? "users" : "nonusers"}
        [List.new(results["users"]||[]), List.new(results["nonusers"]||[])]
      end
    end
  
  
    duck_handle :to_assembler do
      Assembler.new contents:@contents
    end
  
  
    duck_handle :to_binder do
      Binder.new @contents
    end
  
  
    duck_handle :to_interpreter do
      Interpreter.new contents:@contents
    end
  end
end