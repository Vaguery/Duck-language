
module Duck
  class Binder < List
    attr_accessor :contents
  
    def initialize(contents=[])
      @contents = contents
      @needs = []
    end
  
    def recognize_message?(string)
      mine_and_theirs = (Binder.recognized_messages)|contents_recognized_messages
      mine_and_theirs.include?(string.intern)
    end
  
    def contains_an_arg_for?(item)
      contents_recognized_messages.include?(item.needs[0].intern) unless item.needs.empty?
    end
  
    def personally_recognizes?(string)
      !contents_recognized_messages.include?(string.intern) && 
      Binder.recognized_messages.include?(string.intern)
    end
  
    def index_of_next_respondent_to(msg)
      @contents.rindex {|arg| arg.recognize_message?(msg.intern)}
    end
  
    def produce_respondent(msg)
      which = index_of_next_respondent_to(msg.intern)
      which.nil? ? self : @contents[which].deep_copy
    end
  
    def contents_recognized_messages
      @contents.inject([]) {|msgs, item| (msgs|item.class.recognized_messages|item.singleton_methods)}
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
  
    duck_handle :to_list do
      List.new(@contents)
    end
  end
end