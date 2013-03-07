define([
    'underscore',
	'restify',
	'models/Message',
	'Routes'

], function(_, restify, Message, Routes) {

	return {
        INVALID_SERVER_ERROR: "Router requires a server instance.",
        HTTP_ACTIONS: [
            'get',
            'post',
            'put',
            'delete'
        ],
        ALL_ROUTES_REGEX: /\/*/,
        STATIC_CONFIG: {
          'directory': './webapp',
          'default': 'index.html'
        },

		init: function(server) {
			if (!(server && _.isFunction(server.use) && _.isFunction(server.get))) {
				throw new Error(this.INVALID_SERVER_ERROR);
			}

			server.use(restify.bodyParser());

            this._registerRoutes(server);

            // It is important to register all routes before this line
			server.get(this.ALL_ROUTES_REGEX, restify.serveStatic(this.STATIC_CONFIG));
		},

        _registerRoutes: function(server) {
            var me = this;
            _.each(Routes, function(controller, path) {
                _.each(me.HTTP_ACTIONS, function(action) {
                    if (_.isFunction(controller[action])) {
                        server[action](path, controller[action]);
                    }
                });
            });
        }
	};
});