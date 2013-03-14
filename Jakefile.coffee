sys = require('sys')
node_exec = require('child_process').exec

print_exec_res = (error, stdout, stderr) ->
  sys.print "\n#{stdout}"
  sys.print "\n#{stderr}"
  if error?
    console.log "\nexec error:\n#{error}"
  complete()

namespace 'spec', () ->
  desc 'Run node server specs.'
  task 'node', [], () ->
    spec_root = 'spec/node/'
    setup = spec_root + 'SpecSetup.js'

    console.log "\nRunning node specs...:"
    node_exec "jasmine-node --color --coffee --requireJsSetup #{setup} #{spec_root}", print_exec_res

namespace 'run', () ->
  desc 'Start server.'
  task 'server', [], () ->
    console.log '\nStarting server...'
    jake.exec 'node node/server', () ->
      complete()
    ,{
      printStdout: true,
      printStderr: true
    }

namespace 'db', () ->
  desc 'Clean mongodb.'
  task 'clean', [], () ->
    console.log '\nCleaning db...'
    node_exec 'mongo test --eval "db.dropDatabase()"', print_exec_res

  desc 'Start mongodb.'
  task 'start', [], () ->
    console.log '\nForking a process to run mongodb...'
    node_exec 'mongod --fork', print_exec_res
