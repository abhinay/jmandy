require 'uri'

def setup(conf)
  args = conf.get("mapred.args").split(",")
  script = args[2]
  job_name = URI.unescape(args[3])
  conf.set("mandy.job.script", script)
  conf.set("mandy.job.name", job_name)

  require script
  job = JMandy::Job.find_by_name(job_name)
  job.settings.each { |key, value| conf.set(key,value) }

  return nil
end

def map(key, value, context)
  script = context.get_conf.get("mandy.job.script")
  job_name = context.get_conf.get("mandy.job.name")
  require script
  JMandy::Job.find_by_name(job_name).run_map(key, value, context)
end

def reduce(key, values, context)
  script = context.get_conf.get("mandy.job.script")
  job_name = context.get_conf.get("mandy.job.name")
  require script
  JMandy::Job.find_by_name(job_name).run_reduce(key, values, context)
end
