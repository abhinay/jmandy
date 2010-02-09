require "rubygems"
require "uri"
# require "json"
# require "cgi"
require "fileutils"

%w(
  task
  job 
  packer
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
).each {|file| require File.join(File.dirname(__FILE__), 'mandy', file) }

module Mandy
  def job(name, &blk)
    job = Mandy::Job.new(name)
    job.instance_eval(&blk) unless blk.nil?
    Mandy::Job.jobs << job
    job
  end
  module_function :job
end
