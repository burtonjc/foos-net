define([
	'mongoose'
], function(mongoose) {

	var MessageSchema = new mongoose.Schema({
			message: String,
			date: Date
		});

	mongoose.model('Message', MessageSchema);
	return mongoose.model('Message');
});