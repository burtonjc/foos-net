define([
    'marionette',
    'views/navigation',
    'views/footer',
    'regions/modal',
    'router'
], function(Marionette, Navigation, Footer, ModalRegion, AppRouter) {
    FoosNet = new Marionette.Application();
    FoosNet.addRegions({
        navigation: "#top-nav",
        page: "#page-container",
        footer: "#footer",
        modal: ModalRegion
    });

    FoosNet.navigation.show(new Navigation({}));
    FoosNet.footer.show(new Footer({}));

    FoosNet.addInitializer(function(options) {
        new AppRouter(FoosNet);
        Backbone.history.start();
    });

    return FoosNet;
});