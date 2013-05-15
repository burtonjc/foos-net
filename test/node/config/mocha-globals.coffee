chai = require 'chai'
requirejs = require 'requirejs'
sinon = require 'sinon'
_ = require 'underscore'

# requirejs setup
base_context =
  baseUrl: __dirname + '/../../../target/node'
  nodeRequire: require
  paths:
    'mock': __dirname + '/../../node/mock'
requirejs.config(base_context);

# introduce method for injecting mocks
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

  require: (reqs, callback, err) ->
    requirejs.config(spec_context)(reqs, ->
      callback.apply this, arguments
    , err)

# publish globals that all specs can use
global.createContext = createContext
global.expect = chai.expect
global.requirejs = global.define = requirejs
global.should = chai.should()
global.sinon = sinon
global._ = _

# chai plugins
chai.use(require 'sinon-chai')

# global test executers
beforeEach ->
  global.sinon = sinon.sandbox.create()

afterEach ->
  global.sinon.restore()
  # requirejs.nodeRequire.cache = {}
  # requirejs.nodeRequire.main.children = []
  requirejs.config base_context
