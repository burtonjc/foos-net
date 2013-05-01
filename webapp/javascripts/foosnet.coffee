define [
  'marionette',
  'views/navigation',
  'views/footer',
  'regions/modal',
  'router'
], (Marionette, Navigation, Footer, ModalRegion, AppRouter) ->
  FoosNet = new Marionette.Application()
  FoosNet.addRegions 
    navigation: "#top-nav"
    alert: "#alert"
    page: "#page-container"
    footer: "#footer"
    modal: ModalRegion

  FoosNet.navigation.show new Navigation({})
  FoosNet.footer.show new Footer({})

  FoosNet.addInitializer (options) ->
    new AppRouter(FoosNet)
    Backbone.history.start()

  FoosNet
