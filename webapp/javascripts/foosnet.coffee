define [
  'backbone.loader'
  'views/navigation'
  'views/footer'
  'regions/modal'
  'router'
], (Backbone, Navigation, Footer, ModalRegion, AppRouter) ->

  FoosNet = new Backbone.Marionette.Application()
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
