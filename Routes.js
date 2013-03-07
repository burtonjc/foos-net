define([
	'./controllers/MessagesController'

], function(MessageController) {
	var GET		= 'get',
		POST	= 'post',
		PUT		= 'put',
		DELETE	= 'delete';

	return [{
		path: '/messages',
		controller: MessageController,
		httpActions: [GET, POST]
	}];
});