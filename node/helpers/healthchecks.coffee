define [
  'http'

], (http) ->

  "Can request players": (done) ->
    request = http.get
      host: 'localhost'
      port: '8080'
      path: '/players'
      agent: false
    , (response) ->
      done(response.statusCode is 200)
    request.on 'error', (e) ->
      done false, e
    request.end()

  "Can request matches": (done) ->
    request = http.get
      host: 'localhost'
      port: '8080'
      path: '/matches'
      agent: false
    , (response) ->
      done(response.statusCode is 200)
    request.on 'error', (e) ->
      done false, e
    request.end()

  "Can request leagues": (done) ->
    request = http.get
      host: 'localhost'
      port: '8080'
      path: '/leagues'
      agent: false
    , (response) ->
      done(response.statusCode is 200)
    request.on 'error', (e) ->
      done false, e
    request.end()

  "Dummy truth check": (done) ->
    done true
