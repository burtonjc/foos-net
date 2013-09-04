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
  'lib/healthchecker'
  'helpers/healthchecks'

], (cluster, os, restify, router, mongo, logger, HealthChecker, healthChecks) ->
  mongo.init()

  if cluster.isMaster
    numOfNodes = os.cpus().length

    cluster.on 'listening', (worker, address) ->
      logger.info "Worker #{worker.id} listening at #{address.address}:#{address.port}"

    cluster.on 'exit', (worker, code, signal) ->
      logger.info "\nWorker #{worker.id} died with exit code: #{worker.process.exitCode}.\nSpawning new worker...."
      cluster.fork()

    logger.info "\nSpawning workers for #{numOfNodes} nodes...\n"
    workers = (cluster.fork() for cpu in [1..numOfNodes])

  else # isWorker
    mongo.init()
    server = restify.createServer()

    healthchecker = new HealthChecker(server)
    healthchecker.register healthChecks

    router.init(server)

    server.listen 8080
