module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean: ['target']

    coffee:
      node:
        expand: true
        cwd   : 'node'
        src   : '**/*.coffee'
        dest  : 'target/node'
        ext   : '.js'
      webapp:
        expand: true
        cwd   : 'webapp/javascripts'
        src   : '**/*.coffee'
        dest  : 'target/webapp/javascripts'
        ext   : '.js'

    copy:
      webapp:
        expand: true
        cwd   : 'webapp/'
        src   : ['lib/**', 'images/**', 'templates/**']
        dest  : 'target/webapp/'
      node:
        expand: true
        cwd   : 'node/lib'
        src   : ['**/*.js']
        dest  : 'target/node/lib'

    requirejs:
      node:
        options:
          baseUrl       : "target/node/"
          mainConfigFile: "target/node/server.js"
          out           : "target/node/optimized.js"
      webapp:
        options:
          baseUrl       : "target/webapp/javascripts/"
          mainConfigFile: "target/webapp/javascripts/main.js"
          out           : "target/webapp/javascripts/optimized.js"

    sass:
      dist:
        files:
          'target/webapp/stylesheets/all.css': 'webapp/stylesheets/all.scss'

    simplemocha:
      options:
        colors      : true
        ignoreLeaks : false
        reporter    : 'spec'
        slow        : 200
        timeout     : 2000
        util        : 'bdd'
      node:
        src: [
          'test/node/config/mocha-globals.coffee'
          'test/node/**/*.coffee'
        ]

    watch:
      'coffee-node':
        files: ['node/**/*.coffee']
        tasks: ['coffee:node']
      'coffee-webapp':
        files: ['webapp/javascripts/**/*.coffee']
        tasks: ['coffee:webapp']
      'copy-webapp':
        files: [
          'webapp/templates/**/*.html',
          'webapp/lib/**'
        ]
        tasks: ['copy']
      sass:
        files: ['webapp/stylesheets/**/*.scss']
        tasks: ['sass']
      'test-node':
        files: [
          'test/node/**/*.coffee'
          'test/node/**/*.js'
          'node/**/*.coffee'
        ]
        tasks: ['test:node']
      # 'test-webapp':
      #   files: [
      #     'webapp/javascripts/**/*.coffee'
      #     'test/**/*.coffee'
      #     'test/**/*.js'
      #   ]
      #   tasks: ['test:webapp']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.registerTask 'build', ['clean', 'coffee', 'sass', 'copy']
  grunt.registerTask 'test:node', ['clean', 'coffee:node', 'copy:node', 'simplemocha']
  grunt.registerTask 'test:node:watch', ['test:node', 'watch:test-node']

  grunt.registerTask 'node:run', 'Starts the node server', () ->
    child = grunt.util.spawn
      cmd: process.argv[0] #node
      args: ['target/node/server.js']
    , @async()

    child.stdout.pipe process.stdout
    child.stderr.pipe process.stderr
