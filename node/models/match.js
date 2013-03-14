define([
    'mongoose'

], function(mongoose) {
    var Schema = mongoose.Schema,
        MatchSchema = new Schema({
            date: {
                type: Date,
                'default': Date.now
            },
            winners: [{
                type: Schema.Types.ObjectId,
                ref: 'Player'
            }],
            losers: [{
                type: Schema.Types.ObjectId,
                ref: 'Player'
            }]
        });

    mongoose.model('Match', MatchSchema);
    return mongoose.model('Match');
});