requirejs = require 'requirejs'

# requirejs setup
base_context =
  baseUrl: "#{__dirname}/../node"
  nodeRequire: require
  paths:
    'node_modules': "#{__dirname}/../node_modules"
    'mock': "#{__dirname}/node/mock"
    'test': "#{__dirname}/node"
requirejs.config base_context

requirejs [
  'underscore'
  'chai'
  'sinon'
  'sinon-chai'
  'mocha'
  'fs'
  'path'
  'module'
], (_, chai, sinon, sinonChai, Mocha, fs, path, module) ->

  walk = (dir, done) ->
    results = []
    fs.readdir dir, (err, list) ->
      return done(err) if err?
      pending = list.length
      return done(null, results) unless pending
      list.forEach (file) ->
        file = "#{dir}/#{file}"
        fs.stat file, (err, stat) ->
          if stat?.isDirectory()
            walk file, (err, res) ->
              results = results.concat res
              done(null, results) unless --pending
          else
            if file.toLowerCase().indexOf('spec.') isnt -1
              results.push file
            done(null, results) unless --pending

  # for injecting mocks
  createContext = (mocks) ->
    map = {}

    _.each mocks, (value, key) ->
      if  not _.isString(value)
        mockname = "mock/#{key}"
        map[key] = mockname
        requirejs.define mockname, [], ->
          value
      else
        map[key] = value

    spec_context = _.defaults(
      context: Math.floor(Math.random() * 1000000)
      map:
        '*': map
    , base_context)

    define: (reqs, callback, err) ->
      requirejs.config(spec_context)(reqs, ->
        callback.apply this, arguments
      , err)

  root = "#{__dirname}/node"
  walk root, (err, files) ->
    if err?
      console.log "Error reading test files"
      return process.exit 1

    files = (for file in files
      file.replace(root, 'test').replace('.js', ''))

    mocha = new Mocha
      ui: 'bdd',
      reporter: 'spec'
    mocha.suite.emit 'pre-require', global, null, mocha

    chai.use sinonChai

    global.createContext = createContext
    global.sinon = sinon
    global.expect = chai.expect
    global.should = chai.should()

    # global test executers
    beforeEach ->
      global.sinon = sinon.sandbox.create()

    afterEach ->
      global.sinon.restore()

    requirejs files, ->
      mocha.run()
