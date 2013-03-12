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
                $newPlayerIcon = $(me.el).find('i.new-player'),
                input;

            $.get('/players', function(data) {
                me.players = data;

                var t = me._getPlayerTypeAhead().typeahead({
                    source: _.pluck(me.players, "name"),
                    updater: function(playerName) {
                        me._setPlayerStaged(_.findWhere(me.players, {name: playerName}), true);
                        return playerName;
                    }
                }).ready(function() {
                    setTimeout(function() {
                        me._getPlayerTypeAhead().focus();
                    }, 600); // wait for animation to complete
                }).keypress(function() {
                    $newPlayerIcon.popover('hide');
                }).change(function() {
                    if ($(this).val().length) {
                        $newPlayerIcon.popover('enable');
                    } else {
                        $newPlayerIcon.popover('disable');
                    }
                });
            });

            $popoverAttachPoint = $newPlayerIcon.popover({
                placement: 'bottom',
                html: true,
                title: '<h4>Create new player...</h4>'
            }).on('show', function() {
                var val = me._getPlayerTypeAhead().val();
                $popoverAttachPoint.data().popover.options.content = [
                    '<div class="alert-placeholder"></div>',
                    'Create player named: ' + me._getPlayerTypeAhead().val() + '?<br />',
                    '<button class="btn pull-left btn-cancel" aria-hidden="true">Cancel</button>',
                    '<button class="btn btn-primary pull-right btn-create">Create</button>'
                ].join('');
            }).popover('disable');

            $(me.el).delegate('.popover .btn-cancel', 'click', function () {
                $popoverAttachPoint.popover('hide');
            });

            $(me.el).delegate('.popover .btn-create', 'click', function () {
                $(this).attr('disabled', 'disabled');
                var val = me._getPlayerTypeAhead().val();
                $.post('/players', {
                    name: val
                }, function(player, status, xhr) {
                    $popoverAttachPoint.popover('hide');
                    me.players.push(player);
                    me._setPlayerStaged(player, true);
                }).fail(function(a, b, c) {
                    $popoverAttachPoint.popover('hide');
                    $(me.el).find('#alert').append([
                        '<div class="alert alert-error fade in">',
                        '<button type="button" class="close" data-dismiss="alert">x</button>',
                        '<h4 class="alert-heading">There is already a player named ' + val + '</h4>'
                    ].join(''));
                });
            });

            $newPlayerIcon.tooltip({
                title: 'Type full name and press + to add new player',
                placement: 'right'
            });
        },

        _getPlayerTypeAhead: function() {
            return $(this.el).find('input.players-typeahead');
        },

        _setPlayerStaged: function(player, staged) {
            var me = this,
                $newPlayerIcon = $(me.el).find('i.new-player');
            me._togglePlayerSelected(player);

            if (staged) {
                me._addRowForPlayer(player);
                setTimeout(function() {
                    me._getPlayerTypeAhead().val('');
                    if (_.where(me.players, {selected: true}).length > 3) {
                        me._getPlayerTypeAhead().attr('disabled', 'disabled');
                        $newPlayerIcon.popover('disable');
                        $newPlayerIcon.tooltip('disable');
                    }
                }, 10);
            } else {
                this._getRowForPlayer(player).remove();
                if (_.where(me.players, {selected: true}).length < 4) {
                    me._getPlayerTypeAhead().attr('disabled', null);
                    $newPlayerIcon.tooltip('enable');
                }
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