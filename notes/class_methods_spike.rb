class Foo
  class << self; attr_accessor :recog end
  
  def bar
    4
  end
  
  def initialize
  end
  
  def self.r?(msg)
    @recog.include?(msg)
  end
  
  @recog = (self.instance_methods - Object.instance_methods)
end


class Baz < Foo
  def baz
    99
  end
  
  @recog = (self.instance_methods - Object.instance_methods)
end


def silly_message(klass,msg)
  puts "it's #{klass.r?(msg)} that Foo recognizes #{msg.inspect} as a non-inherited message"
end


silly_message(Foo,:self)
silly_message(Foo,:bar)
silly_message(Baz,:bar)
silly_message(Baz,:baz)
silly_message(Foo,:baz)