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

], (cluster, os, restify, router, mongo) ->
  mongo.init()

  if cluster.isMaster
    numCPUs = os.cpus().length
    console.log "Forking process for #{numCPUs} nodes..."
    cluster.fork() for cpu in [1..numCPUs]
    cluster.on 'exit', (worker, code, signal) ->
      console.log "Worker #{worker.process.pid} died."
  else
    server = restify.createServer()
    router.init(server)
    server.listen 8080, () ->
      console.log "#{server.name} listening at #{server.url}"
