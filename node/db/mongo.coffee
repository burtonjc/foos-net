define [
  'mongoose'
  'db/mongoconfig'
  'cluster'

], (mongoose, MongoConfig, cluster) ->

  init: () ->
    workerId = cluster.worker.id
    console.log "Worker #{workerId} connecting to MongoDB..."

    mongoose.connect MongoConfig.creds.mongoose_auth
    connection = mongoose.connection
    connection.on 'error', console.error.bind(console, "Worker #{workerId} failed to connect to MongoDB:")
    connection.once 'open', () ->
      console.log "Worker #{workerId} successfully connected to MongoDB!"
