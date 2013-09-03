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
      test:
        expand: true
        cwd   : 'test'
        src   : '**/*.coffee'
        dest  : 'target/test'
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
        tasks: ['node:test']
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

  grunt.registerTask 'build', ['clean', 'coffee', 'sass', 'copy']
  grunt.registerTask 'test:node:watch', ['test:node', 'watch:test-node']

  grunt.registerTask 'node:run', 'Starts the node server', () ->
    spawn = require('child_process').spawn
    runner = spawn process.argv[0], ['target/node/server.js'], {
      stdio: 'inherit'
      env: process.env
    }
    runner.on 'close', @async()

  grunt.registerTask 'node:debug', 'Starts the node server', () ->
    spawn = require('child_process').spawn
    runner = spawn process.argv[0], ['--debug', 'target/node/server.js'], {
      stdio: 'inherit'
      env: process.env
    }
    runner.on 'close', @async()

  grunt.registerTask 'node:test', 'runs all node tests', () ->
    spawn = require('child_process').spawn
    runner = spawn process.argv[0], ["target/test/node_runner.js"], {
      stdio: 'inherit'
      env: process.env
    }
    runner.on 'close', @async()
