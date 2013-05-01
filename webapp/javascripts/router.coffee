define [
    'underscore'
    'jquery'
    'marionette'

], (_, $, Marionette) ->

	Marionette.AppRouter.extend
    Application: null,

		routes:
      'leaderboard': 'leaderboardPage'
      'stats': 'statsPage'

      # Keep default route as the last one
      '*actions': 'homePage'

    initialize: (Application) ->
      @Application = Application

    homePage: () ->
      app = @Application
      require ['views/home/page'],  (HomePage) ->
        app.page.show new HomePage()

    leaderboardPage: () ->
      app = @Application
      require ['views/leaderboard/page'], (LeaderBoardPage) ->
        app.page.show new LeaderBoardPage()

    statsPage: () ->
