define([
	'mongoose'

], function(mongoose) {
	var PlayerSchema = new mongoose.Schema({
        name: {
            type: String,
            required: true,
            unique: true
        },
        elo: Number
    });

	mongoose.model('Player', PlayerSchema);
	return mongoose.model('Player');
});