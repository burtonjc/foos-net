define([
	'mongoose'

], function(mongoose) {
	var PlayerSchema = new mongoose.Schema({
        name: String,
        elo: Number
    });

	mongoose.model('Player', PlayerSchema);
	return mongoose.model('Player');
});