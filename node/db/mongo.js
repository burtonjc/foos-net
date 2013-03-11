define([
	'mongoose',
	'./mongoconfig'

], function(mongoose, MongoConfig) {
	return {
		init: function() {
			console.log('Connecting to MongoDB...');
			mongoose.connect(MongoConfig.creds.mongoose_auth);
			connection = mongoose.connection;
			connection.on('error', console.error.bind(console, 'Error connecting to MongoDB:'));
			connection.once('open', function callback() {
				console.log('MongoDb connection open!');
			});
		}
	};
});
