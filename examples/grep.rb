require "rubygems"
require "jmandy"

JMandy.job "Grep" do
  map do |key, line|
    if line =~ /Alice/
      emit(line,0)
    end
  end
end
