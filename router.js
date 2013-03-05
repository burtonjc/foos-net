define([
	'restify',
	'./models/Message',
	'./routes'

], function(restify, Message, routes) {

	function registerRoutes(server) {
		var route, action;
		for (var i in routes) {
			route = routes[i];
			for (var j in route.httpActions) {
				action = route.httpActions[j];
				server[action](route.path, route.controller[action]);
			}
		}
	}

	return {
		init: function(server) {
			if (!(server && server.use)) {
				throw new Error("Router requires a server instance.");
			}

			server.use(restify.bodyParser());
			registerRoutes(server);
			server.get(/\/*/, restify.serveStatic({
				'directory': './webapp',
				'default': 'index.html'
			}));
		}
	};
});