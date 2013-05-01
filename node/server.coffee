define = require 'requirejs'
define.config
  baseUrl: __dirname
  nodeRequire: require

define [
	'restify',
	'router',
	'db/mongo'

], (restify, router, mongo) ->
  mongo.init()

  server = restify.createServer()
  router.init(server)
  server.listen 8080, () ->
    console.log('%s listening at %s', server.name, server.url)
