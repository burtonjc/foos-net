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
  'helpers/logger'
  'winston'
  'lib/healthchecker'
  'helpers/healthchecks'

], (cluster, os, restify, router, mongo, logger, winston, HealthChecker, healthChecks) ->
  logger.init()
  mongo.init()

  if cluster.isMaster
    numCPUs = os.cpus().length
    winston.info "Forking process for #{numCPUs} nodes..."
    cluster.fork() for cpu in [1..numCPUs]
    cluster.on 'exit', (worker, code, signal) ->
      winston.info "Worker #{worker.process.pid} died."
  else
    server = restify.createServer()

    healthchecker = new HealthChecker(server)
    healthchecker.register healthChecks

    router.init(server)

    server.listen 8080, () ->
      winston.info "#{server.name} listening at #{server.url}"
