define([
    'jquery',
    'underscore',
    'marionette',
    'text!templates/game/modal.html'
], function($, _, Marionette, GameModalTpl) {
    return Marionette.ItemView.extend({
        template: _.template(GameModalTpl),

        players: null,

        onRender: function() {
            var me = this,
                input;

            $.get('/players', function(data) {
                me.players = data;

                me._getPlayerTypeAhead().typeahead({
                    source: _.pluck(me.players, "name"),
                    updater: function(playerName) {
                        me._setPlayerStaged(_.findWhere(me.players, {name: playerName}), true);
                        return playerName;
                    }
                });
            });
        },

        _getPlayerTypeAhead: function() {
            return $(this.el).find('input.players-typeahead');
        },

        _setPlayerStaged: function(player, staged) {
            var me = this;
            me._togglePlayerSelected(player);

            if (staged) {
                me._addRowForPlayer(player);
                setTimeout(function() {
                    me._getPlayerTypeAhead().val('');
                }, 10);
            } else {
                this._getRowForPlayer(player).remove();
            }
        },

        _togglePlayerSelected: function(player) {
            player.selected = player.selected ? undefined : true;

            this._getPlayerTypeAhead().data('typeahead').source = _.chain(this.players)
                                                                 .where({selected: undefined})
                                                                 .pluck("name")
                                                                 .value();
        },

        _addRowForPlayer: function(player) {
            var newRow = [
                '<tr class="'+player._id+'"><td>',
                player.name,
                '</td><td>',
                player.elo,
                '</td><td><i class="icon-remove close"></i></td></tr>'
            ].join('');

            $(this.el).find('.table > tbody:last').append(newRow);
            this._getRowForPlayer(player).find('i.close').click($.proxy(this._setPlayerStaged, this, player, false));
        },

        _getRowForPlayer: function(player) {
            return $(this.el).find('.table tr.' + player._id);
        }
    });
});