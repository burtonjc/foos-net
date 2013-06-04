define [
  'mongoose'
  'db/mongoconfig'
  'winston'

], (mongoose, MongoConfig, winston) ->
  init: () ->
    winston.info 'Connecting to MongoDB...'
    mongoose.connect MongoConfig.creds.mongoose_auth
    connection = mongoose.connection
    connection.on 'error', console.error.bind(console, 'Error connecting to MongoDB:')
    connection.once 'open', () ->
      winston.info 'MongoDb connection open!'
