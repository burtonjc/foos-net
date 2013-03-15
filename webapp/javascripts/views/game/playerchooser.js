define([
    'jquery',
    'underscore',
    'marionette',
    'models/player',
    'collections/players',
    'views/game/playerlistrow',
    // 'crypto',
    'tpl!templates/game/playerchooser.html'
], function($, _, Marionette, Player, PlayersCollection, PlayerListRow, /*Crypto, */PlayerChooserTpl) {

    return Marionette.CompositeView.extend({
        template: PlayerChooserTpl,
        className: 'well',
        itemView: PlayerListRow,
        itemViewContainer: 'tbody',

        collection: new PlayersCollection(),

        ui: {
            newPlayerIcon: '.new-player',
            playerTypeAhead: 'input.players-typeahead',
            stagedPlayerList: '.table tbody'
        },

        collectionEvents: {
            'add': '_updateTypeAheadSource',
            'remove': '_updateTypeAheadSource'
        },

        initialize: function(opts) {
            _.bindAll(this);
            this.on('ready', this._ready);
            this.on('notready', this._notready);
        },

        onRender: function() {
            var me = this;

            new PlayersCollection().fetch({
                success: function(collection, response, options) {
                    me.players = collection;

                    // In case we are reopening the dialog
                    _.each(me.collection.models, function(player) {
                        me.players.where({_id: player.get('_id')})[0].set('staged', true);
                    });

                    me._initializeNewPlayerPopover();
                    me._initializeTypeAhead();

                    me._updateTypeAheadSource();
                }
            });

            me.on('itemview:removeclicked', function(view) {
                var player = view.model;
                me._setPlayerStaged(me.collection.get(player.id), false);
                me.ui.playerTypeAhead.focus();
            });
        },

        _initializeTypeAhead: function() {
            var me = this;

            me.ui.playerTypeAhead.typeahead({
                updater: function(playerName) {
                    me._setPlayerStaged(me.players.where({name: playerName})[0], true);
                    return playerName;
                }
            }).ready(function() {
                setTimeout(function() {
                    me.ui.playerTypeAhead.focus();
                }, 600); // wait for animation to complete
            }).keypress(function() {
                me.ui.newPlayerIcon.popover('hide');
            });

            me.ui.newPlayerIcon.tooltip({
                title: 'Add new player',
                placement: 'right'
            });
        },

        _initializeNewPlayerPopover: function() {
            var me = this;

            me.ui.newPlayerIcon.popover({
                placement: 'bottom',
                html: true,
                title: '<h4>Create new player...</h4>'
            }).on('show', function() {
                var val = me.ui.playerTypeAhead.val();
                me.ui.newPlayerIcon.data().popover.options.content = [
                    '<div class="alert-placeholder"></div>',
                    '<input class="new-player-name" type="text" placeholder="Name">',
                    '<input class="new-player-email" type="text" placeholder="Email (used for Gravatar)">',
                    '<button class="btn pull-left btn-cancel" aria-hidden="true">Cancel</button>',
                    '<button class="btn btn-primary pull-right btn-create">Create</button>'
                ].join('');
            });

            $(me.el).delegate('.popover .btn-cancel', 'click', function () {
                me.ui.newPlayerIcon.popover('hide');
            });

            $(me.el).delegate('.popover .btn-create', 'click', function () {
                var name = $('.new-player-name').val(),
                    email = $('.new-player-email').val(),
                    player = new Player();

                player.save({
                    name: name,
                    email: email
                }, {
                    success: function(model, response, options) {
                        me.ui.newPlayerIcon.popover('hide');
                        me.players.add(model);
                        me._setPlayerStaged(model, true);
                    },
                    error: function(model, xhr, options) {
                        me.ui.newPlayerIcon.popover('hide');
                        me.trigger('error', 'There is already a player named ' + val);
                    }
                });
            });
        },

        _setPlayerStaged: function(player, staged) {
            var me = this;

            player.set('staged', staged ? true : undefined);
            numOfPlayersStaged = me.players.where({staged: true}).length;

            if (staged) {
                me.collection.add(player);
                setTimeout(function() {
                    me.ui.playerTypeAhead.val('');
                }, 10);
            } else {
                me.collection.remove(player);
            }
        },

        _updateTypeAheadSource: function() {
            var unstagedPlayerList = this.players.where({staged: undefined}),
                updatedSource = _.chain(unstagedPlayerList)
                                 .pluck('attributes')
                                 .pluck("name")
                                 .value();

            if (this.collection.length < 4) {
                this.trigger('notready');
            } else {
                this.trigger('ready');
            }

            this.ui.playerTypeAhead.data('typeahead').source = updatedSource;
        },

        _ready: function() {
            this.ui.playerTypeAhead.attr('disabled', 'disabled');
            this.ui.newPlayerIcon.removeClass('pointer');
        },

        _notready: function() {
            this.ui.playerTypeAhead.removeAttr('disabled');
            this.ui.newPlayerIcon.addClass('pointer');
        }
    });
});