define [
  'exports'
  'backbone.loader'
  'views/navigation'
  'views/footer'
  'regions/modal'
  'router'
  'domain/cache'
], (exports, Backbone, Navigation, Footer, ModalRegion, AppRouter, DomainCache) ->

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

  Backbone.Relational.store.addModelScope DomainCache.getModels()
  Backbone.Relational.store.addModelScope DomainCache.getCollections()

  FoosNet
