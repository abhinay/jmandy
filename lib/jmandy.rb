require "rubygems"
require "uri"
require "fileutils"

%w(
  task
  job 
  support/tuple 
  support/array_serializer 
  mappers/base_mapper 
  mappers/transpose_mapper 
  mappers/pass_through_mapper 
  reducers/base_reducer 
  reducers/pass_through_reducer 
  reducers/sum_reducer 
  reducers/max_reducer 
  reducers/min_reducer
  reducers/transpose_reducer
  errors
).each {|file| require File.join(File.dirname(__FILE__), 'jmandy', file) }

module JMandy
  def job(name, &blk)
    job = JMandy::Job.new(name)
    job.instance_eval(&blk) unless blk.nil?
    JMandy::Job.jobs << job
    job
  end
  module_function :job
end
