requirejs = require 'requirejs'
requirejs.config
  name: 'server'
  baseUrl: __dirname
  nodeRequire: require
  paths:
    'node_modules': "../node_modules/"

requirejs [
  'cluster'
  'os'
  'restify'
  'router'
  'db/mongo'
  'lib/lubdub/lubdub'
  'lib/healthchecker'
  'helpers/healthchecks'

], (cluster, os, restify, router, mongo, LubDub, HealthChecker, healthChecks) ->
  mongo.init()

  if cluster.isMaster
    numOfNodes = os.cpus().length
    console.log "Forking process for #{numOfNodes} nodes..."
    cluster.fork() for cpu in [1..numOfNodes]
    cluster.on 'exit', (worker, code, signal) ->
      console.log "Worker #{worker.process.pid} died."
  else
    server = restify.createServer()

    healthchecker = new HealthChecker(server)
    healthchecker.register healthChecks
    
    router.init(server)
    
    new LubDub 1100, 1000

    server.listen 8080, () ->
      console.log "#{server.name} listening at #{server.url}"
