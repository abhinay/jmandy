require 'uri'

def setup(conf)
  args = conf.get("mapred.args").split(",")
  conf.set("mandy.job.script", args[2])
  conf.set("mandy.job.name", URI.unescape(args[3]))
end

def map(key, value, context)
  script = context.get_conf.get("mandy.job.script")
  job_name = context.get_conf.get("mandy.job.name")
  require script
  Mandy::Job.find_by_name(job_name).run_map(key, value, context)
end

def reduce(key, values, context)
  script = context.get_conf.get("mandy.job.script")
  job_name = context.get_conf.get("mandy.job.name")
  require script
  Mandy::Job.find_by_name(job_name).run_reduce(key, values, context)
end
