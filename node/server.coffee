define = require 'requirejs'
define.config
  baseUrl: __dirname
  nodeRequire: require

define [
  'cluster'
  'os'
	'restify'
	'router'
	'db/mongo'

], (cluster, os, restify, router, mongo) ->
  mongo.init()

  if cluster.isMaster
    numCPUs = Math.min 2, os.cpus().length
    console.log "Forking process for #{numCPUs} nodes..."
    cluster.fork() for cpu in [1..numCPUs]
    cluster.on 'exit', (worker, code, signal) ->
      console.log "Worker #{worker.process.pid} died."
  else
    server = restify.createServer()
    router.init(server)
    server.listen 8080, () ->
      console.log "#{server.name} listening at #{server.url}"
