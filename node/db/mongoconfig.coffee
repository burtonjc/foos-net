# TODO: remove this file from the public repository before the app is deployed
define () ->
  creds:
    mongoose_auth: process.env.MONGO_URL || 'mongodb://localhost/test'
