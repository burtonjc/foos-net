define [
  'mongoose'
  'db/mongoconfig'
  'cluster'

], (mongoose, MongoConfig, cluster) ->

  init: (done) ->
    if cluster.worker?
      workerId = cluster.worker.id
    else
      workerId = 1
    console.log "Worker #{workerId} connecting to MongoDB..."

    mongoose.connect MongoConfig.creds.mongoose_auth
    connection = mongoose.connection

    connection.on 'error', console.error.bind(console, "Worker #{workerId} failed to connect to MongoDB:")
    connection.once 'open', () ->
      console.log "Worker #{workerId} successfully connected to MongoDB!"
      done?()

  shutdown: (done) ->
    mongoose.connection.close done
