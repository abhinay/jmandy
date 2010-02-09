# normally just requiring mandy through gems is fine.
# we try and load a local version first in this example so that our specs don't use gem files.
# PATH HACK
require "lib/mandy"

# a job can consist of a map block, a reduce block or both along with some configuration options.
# this job counts words in the input document.
Mandy.job "Word Count" do
  map_tasks 5
  reduce_tasks 5
  
  map do |key, value|
    words = {}
    value.split(' ').each do |word|
      word.downcase!
      word.gsub!(/\W|[0-9]/, '')
      next if word.size == 0
      words[word] ||= 0 
      words[word] += 1
    end
    words.each {|word, count| emit(word, count) }
  end
  
  reduce(Mandy::Reducers::SumReducer)
end

# this job takes the output of the wordcount and draws a very simple histogram
Mandy.job "Histogram" do
  RANGES = [0..1, 2..3, 4..5, 6..10, 11..20, 21..30, 31..40, 41..50, 51..100, 101..200, 201..300, 301..10_000, 10_001..99_999]
  map do |word, count|
    range = RANGES.find {|range| range.include?(count.to_i) }
    emit("#{range.first.to_s.rjust(5,'0')}-#{range.last.to_s.rjust(5,'0')}", 1)
  end
  
  reduce do |range, counts|
    total = counts.inject(0) {|sum,count| sum+count.to_i }
    emit(range, '|'*(total/20))
  end
end
