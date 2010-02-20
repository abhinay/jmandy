module JMandy
  module Reducers
    class MinReducer < Base
      def reduce(key,values)
        values.map! {|value| value.to_f}
        emit(key, values.min)
      end
    end
  end
end
