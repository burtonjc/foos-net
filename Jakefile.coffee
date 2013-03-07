std_opts = {
  printStdout: true,
  printStderr: true
}

namespace 'spec', () ->
  desc 'Run node server specs.'
  task 'node', [], () ->
    spec_root = 'spec/node/'
    setup = spec_root + 'SpecSetup.js'

    console.log "\nRunning node specs...:"
    jake.exec "jasmine-node --color --coffee --requireJsSetup #{setup} #{spec_root}", () ->
      complete()
    , std_opts

namespace 'run', () ->
  desc 'Start mongodb.'
  task 'db', [], () ->
    console.log '\nForking a process to run mongodb...'
    jake.exec 'mongod --fork', () ->
      complete()
    , std_opts

  desc 'Start server.'
  task 'server', [], () ->
    console.log '\nStarting server...'
    jake.exec 'node node/server', () ->
      complete()
    , std_opts
