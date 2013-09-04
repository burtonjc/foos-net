define [
  'mongoose'
  'db/mongoconfig'
  'helpers/logger'
  'cluster'

], (mongoose, MongoConfig, logger, cluster) ->

  init: (done) ->
    if cluster.worker?
      workerId = cluster.worker.id
    else
      workerId = 1

    logger.info "Worker #{workerId} connecting to MongoDB..."
    mongoose.connect MongoConfig.creds.mongoose_auth
    connection = mongoose.connection

    connection.on 'error', (err) -> logger.error "Worker #{workerId} failed to connect to MongoDB: #{err}"
    connection.once 'open', () ->
      logger.info "Worker #{workerId} successfully connected to MongoDB!"
      done?()

  shutdown: (done) ->
    mongoose.connection.close done
