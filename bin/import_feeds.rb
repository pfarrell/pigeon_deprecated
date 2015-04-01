require 'rake'
require './app'
Dir.glob('./lib/tasks/*.rake').each { |r| load r }

def generate_pid(file_name, process_id)
  File.open(file_name, 'w+') {|f| f.write($$) }
end

def running?(file_name)
  retval = true
  if !File.exists?(file_name)
    generate_pid(file_name, $$)
    retval = false
  else
    file_pid = open(file_name).gets
    begin
      Process.kill 0, file_pid.to_i
    rescue
      generate_pid(file_name, $$)
      retval = false
    end
  end
  retval
end

unless running?("/tmp/pigeon_feeds.pid")
  Rake.application["import:feeds"].invoke
end
