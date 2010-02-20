module JMandy
  module Mappers
    class PassThroughMapper < Base
      def map(key, value)
        # default map is simply a pass-through
        emit(key, value)
      end
    end
  end
end