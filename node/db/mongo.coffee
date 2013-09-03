define [
  'mongoose'
  'db/mongoconfig'
  'winston'
  'cluster'

], (mongoose, MongoConfig, winston, cluster) ->

  init: (done) ->
    if cluster.worker?
      workerId = cluster.worker.id
    else
      workerId = 1

    winston.info "Worker #{workerId} connecting to MongoDB..."
    mongoose.connect MongoConfig.creds.mongoose_auth
    connection = mongoose.connection

    connection.on 'error', (err) -> winston.error "Worker #{workerId} failed to connect to MongoDB: #{err}"
    connection.once 'open', () ->
      winston.info "Worker #{workerId} successfully connected to MongoDB!"
      done?()

  shutdown: (done) ->
    mongoose.connection.close done
