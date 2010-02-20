module JMandy
  module Reducers
    class TransposeReducer < Base
      def reduce(key,values)
        values.each {|value| emit(value, key) }
      end
    end
  end
end
