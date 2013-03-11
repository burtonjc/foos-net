define([
    'underscore',
    'jquery',
    'bootstrap',
    'marionette',
    'text!templates/home/page.html'
], function(_, $, Bootstrap, Marionette, HomePageTpl) {
    return Marionette.ItemView.extend({
        className: 'home-page',
        template: _.template(HomePageTpl),

        onRender: function() {
            $(this.el).find('.start-game').click(function() {
                require(['views/game/modal', 'foosnet'], function(GameModal, FoosNet) {
                    FoosNet.modal.show(new GameModal());
                });
            });
        }
    });
});