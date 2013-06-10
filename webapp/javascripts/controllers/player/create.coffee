define [
  'jquery'
  'underscore'
  'controllers/modal'
  'views/player/form'

], ($, _, ModalController, PlayerFormView) ->
  ModalController.extend
    sequence: [
      (next) ->
        playerForm = new PlayerFormView
        @showView playerForm,
          header: 'Create your player...'
          submit: ->
            playerForm.model.save null,
              success: (model, response, opts) ->
                next()
    ]
