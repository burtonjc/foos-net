define([
    '../models/Message'

], function(Message) {

	return {
		get: function(request, response, next) {
			Message.find().limit(20).execFind(function(arr, data) {
				response.send(data);
			});
		},

		post: function(request, response, next) {
			var message = new Message();
			message.message = request.params.message;
			message.date = new Date();
			message.save(function() {
				response.send(request.body);
			});
		}
	};
});