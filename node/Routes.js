define([
	'controllers/MessagesController'

], function(MessagesController) {
	var GET		= 'get',
		POST	= 'post',
		PUT		= 'put',
		DELETE	= 'delete';

	return [{
		path: '/messages',
		controller: MessagesController,
		httpActions: [GET, POST]
	}];
});