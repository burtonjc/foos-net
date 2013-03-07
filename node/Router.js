define([
	'restify',
	'models/Message',
	'Routes'

], function(restify, Message, routes) {

	return {
        INVALID_SERVER_ERROR: "Router requires a server instance.",

		init: function(server) {
			if (!(server && server.use)) {
				throw new Error(this.INVALID_SERVER_ERROR);
			}

			server.use(restify.bodyParser());
			this._registerRoutes(server);
			server.get(/\/*/, restify.serveStatic({
				'directory': './webapp',
				'default': 'index.html'
			}));
		},

        _registerRoutes: function(server) {
            var route, action;
            for (var i in routes) {
                route = routes[i];
                for (var j in route.httpActions) {
                    action = route.httpActions[j];
                    server[action](route.path, route.controller[action]);
                }
            }
        }
	};
});