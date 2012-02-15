#encoding: utf-8
module Duck
  
  class ComplexityError < RuntimeError
  end
  
  class Error < Item
    def to_s
      "err:[#{@value}]"
    end
  end
end