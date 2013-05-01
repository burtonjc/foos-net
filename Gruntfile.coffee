module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean: ['target']

    coffee:
      compile:
        files: [{
          expand: true
          cwd: 'node'
          src: '**/*.coffee'
          dest: 'target/node'
          ext: '.js'
        },{
          expand: true
          cwd: 'webapp/javascripts'
          src: '**/*.coffee'
          dest: 'target/webapp/javascripts'
          ext: '.js'
        }]

    copy:
      main:
        files: [{
          expand: true
          cwd: 'webapp/'
          src: ['lib/**', 'images/**', 'templates/**']
          dest: 'target/webapp/'
        },{
          expand: true
          cwd: 'node/lib'
          src: ['**']  
          dest: 'target/node/lib'
        }]

    jasmine_node:
      # source: 'node'
      projectRoot: 'spec/node/'
      requirejs: 'spec/node/SpecSetup.js'
      extensions: 'coffee'
      useCoffee: true
      colors: true

    # requirejs:
    #   compile:
    #     options:
    #       baseUrl: "target/javascripts/"
    #       mainConfigFile: "public/javascripts/main.js"
    #       out: "public/javascripts/optimized.js"

    sass:
      dist:
        files:
          'target/webapp/stylesheets/all.css': 'webapp/stylesheets/all.scss'

    watch:
      scripts:
        files: ['webapp/coffeescripts/**/*.coffee']
        tasks: ['coffee']
        options:
          nospawn: true

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-jasmine-node'
  # grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', ['clean', 'coffee', 'sass', 'copy']
  grunt.registerTask 'test', ['clean', 'build', 'jasmine_node']
