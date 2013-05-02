sys = require('sys')
node_exec = require('child_process').exec

print_exec_res = (error, stdout, stderr) ->
  sys.print "\n#{stdout}"
  sys.print "\n#{stderr}"
  if error?
    console.log "\nexec error:\n#{error}"
  complete()

namespace 'db', () ->
  desc 'Clean mongodb.'
  task 'clean', [], () ->
    console.log '\nCleaning db...'
    node_exec 'mongo --eval "db.dropDatabase()" test', print_exec_res

  desc 'Start mongodb.'
  task 'start', [], () ->
    console.log '\nForking a process to run mongodb...'
    node_exec 'mongod --fork', print_exec_res
