module Duck
  require 'stringio'
  Encoding.default_external="UTF-8"
  
  require_relative './item_class'
  require_relative './bool_class'
  require_relative './script_class'
  require_relative './number_class'
  require_relative './int_class'
  require_relative './decimal_class'
  require_relative './closure_class'
  require_relative './error_class'
  require_relative './message_class'
  require_relative './local_class'
  require_relative './list_class'
  require_relative './assembler_class'
  require_relative './collector_class'
  require_relative './pipe_class'
  require_relative './interpreter_class'
  require_relative './variable_class'
  require_relative './binder_class'
end