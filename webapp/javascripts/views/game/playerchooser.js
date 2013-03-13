define([
    'jquery',
    'underscore',
    'marionette',
    'models/player',
    'collections/players',
    'views/game/playerlistrow',
    'tpl!templates/game/playerchooser.html'
], function($, _, Marionette, Player, PlayersCollection, PlayerListRow, PlayerChooserTpl) {

    return Marionette.CompositeView.extend({
        template: PlayerChooserTpl,
        className: 'well',
        itemView: PlayerListRow,
        itemViewContainer: 'tbody',

        collection: new PlayersCollection(),

        ui: {
            newPlayerIcon: 'i.new-player',
            playerTypeAhead: 'input.players-typeahead',
            stagedPlayerList: '.table tbody'
        },

        collectionEvents: {
            'add': '_updateTypeAheadSource',
            'remove': '_updateTypeAheadSource'
        },

        initialize: function(opts) {
            _.bindAll(this);
            this.on('complete', this._onComplete);
            this.on('incomplete', this._onIncomplete);
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

                    me._initializeTypeAhead();
                    me._initializeNewPlayerPopover();
                }
            });

            me.ui.stagedPlayerList.delegate('.icon-remove', 'click', function(evt) {
                // This is nasty...
                var playerName = evt.target.parentElement.parentElement.firstChild.innerHTML;
                me._setPlayerStaged(me.collection.where({name: playerName})[0], false);
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
            }).change(function() {
                if ($(this).val().length > 0) {
                    me.ui.newPlayerIcon.popover('enable');
                } else {
                    me.ui.newPlayerIcon.popover('disable');
                }
            }).keypress(function() {
                me.ui.newPlayerIcon.popover('hide');
            });
            me._updateTypeAheadSource();

            me.ui.newPlayerIcon.tooltip({
                title: 'Type full name and press + to add new player',
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
                    'Create player named: ' + me.ui.playerTypeAhead.val() + '?<br />',
                    '<button class="btn pull-left btn-cancel" aria-hidden="true">Cancel</button>',
                    '<button class="btn btn-primary pull-right btn-create">Create</button>'
                ].join('');
            }).popover('disable');

            $(me.el).delegate('.popover .btn-cancel', 'click', function () {
                me.ui.newPlayerIcon.popover('hide');
            });

            $(me.el).delegate('.popover .btn-create', 'click', function () {
                $(this).attr('disabled', 'disabled');
                var val = me.ui.playerTypeAhead.val(),
                    player = new Player();

                player.save({name: val}, {
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
                    me.ui.newPlayerIcon.popover('disable');
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
                this.trigger('incomplete');
            } else {
                this.trigger('complete');
            }

            this.ui.playerTypeAhead.data('typeahead').source = updatedSource;
        },

        _onComplete: function() {
            this.ui.playerTypeAhead.attr('disabled', 'disabled');
            this.ui.newPlayerIcon.tooltip('disable');
            this.ui.newPlayerIcon.popover('disable');
            this.ui.newPlayerIcon.removeClass('pointer');
        },

        _onIncomplete: function() {
            this.ui.playerTypeAhead.removeAttr('disabled');
            this.ui.newPlayerIcon.tooltip('enable');
            this.ui.newPlayerIcon.addClass('pointer');
        }
    });
});