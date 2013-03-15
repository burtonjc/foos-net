define([
	'mongoose'

], function(mongoose) {
    function trimAndLowerCase(v) {
        return v.trim().toLowerCase();
    }

	var PlayerSchema = new mongoose.Schema({
        name: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true,
            unique: true,
            set: trimAndLowerCase
        },
        elo: Number
    });

	mongoose.model('Player', PlayerSchema);
	return mongoose.model('Player');
});