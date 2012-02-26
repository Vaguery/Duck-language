
module Duck
  class Binder < List
    attr_accessor :contents
    
    
    def initialize(contents=[])
      @contents = contents
      @needs = []
    end
    
    
    def deep_copy
      Binder.new( @contents.collect {|item| item.deep_copy})
    end
    
    
    
    def recognize_message?(string)
      mine_and_theirs = contents_recognize_message?(string) || Binder.recognized_messages.include?(string.intern)
    end
    
    
    def contents_recognize_message?(string)
      !@contents.detect {|item| item.recognize_message?(string)}.nil?
    end
    
    
    def contains_an_arg_for?(item)
      contents_recognize_message?(item.needs[0]) unless item.needs.empty?
    end
    
    
    def personally_recognizes?(string)
      !contents_recognize_message?(string) && 
      Binder.recognized_messages.include?(string.intern)
    end
    
    
    def index_of_next_respondent_to(msg)
      @contents.rindex {|arg| arg.recognize_message?(msg.intern)}
    end
    
    
    def produce_respondent(msg)
      which = index_of_next_respondent_to(msg.intern)
      if which.nil?
        result = personally_recognizes?(msg) ? self.deep_copy : nil
      else
        if @contents[which].kind_of?(Binder)
          result = @contents[which].produce_respondent(msg)
        else
          result = @contents[which].deep_copy
        end
      end
      return result
    end
    
    
    def self.from_key_value_hash(hash={})
      result = Binder.new
      hash.each do |key,value|
        raise ArgumentError, "Binder.from_key_value_hash called with invalid key" unless
          [Symbol, String].include?(key.class)
        raise ArgumentError, "Binder.from_key_value_hash called with a non-Duck value" unless
          value.kind_of?(Item)
        result.contents << Variable.new(key, value)
      end
      result
    end
    
    
    def to_s
      (@contents.inject("{") {|s,i| s+i.to_s+", "}).chomp(", ") + "}"
    end
    
    
    # DUCK MESSAGES
    
    duck_handle :size do
      count = (@contents).inject(1) {|sum,item| sum + item.size[1].value}
      [self, Int.new(count)]
    end
    
    
    duck_handle :to_binder do
      self
    end
    
    
    duck_handle :to_list do
      List.new(@contents)
    end
  end
end