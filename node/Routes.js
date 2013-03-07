define([
	'controllers/MessagesController'

], function(MessagesController) {

	return {
        '/messages': MessagesController
        // ,
        // '/someotherpath': SomeOtherController
    };
});