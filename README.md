= JMandy - Simplified Hadoop distribution for Ruby code

== Description

This is a fork of Mandy. Instead of using the Hadoop Streaming API to run the map and reduce jobs, JMandy uses a fork of jruby-on-hadoop (http://github.com/abhinay/jruby-on-hadoop) gem to run them in JRuby.
See examples/word_count.rb for a demo of some functionality. 

== Install

Required gems are all on GemCutter.

1. Upgrade your rubygem to 1.3.5
2. sudo gem install jmandy

== Usage

1. Run Hadoop cluster on your machines and set HADOOP_HOME env variable.
2. put files into your hdfs. ex) test/inputs/file1
3. Now you can run 'joh' like below:
 $ jmandy-hadoop examples/word_count.rb test/inputs/file1 test/outputs
You can get Hadoop job results in your hdfs test/outputs/part-*

== Example 
see also examples/word_count.rb

require "rubygems"
require "jmandy"

JMandy.job "Word Count" do
  map do |key, value|
    words = {}
    value.split(' ').each do |word|
      word = word.downcase.gsub!(/\W|[0-9]/, '')
      next if word.size == 0
      words[word] ||= 0 
      words[word] += 1
    end
    words.each {|word, count| emit(word, count) }
  end
  
  reduce(JMandy::Reducers::SumReducer)
end

== Authors
"Andy Kent", "Paul Ingles", "Abhinay Mehta"

== Copyright
Mandy is licensed under the MIT Licence, please see LICENCE for further information.
