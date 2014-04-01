module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-newer')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register',
          log: true
        src: ['test/**/*.coffee']
    watch:
      coffee:
        files: ['app/models/*.coffee', 'config/*.coffee']
        tasks: ['test']
      test:
        files: ['test/**/*.coffee']
        tasks: ['newTest']
    coffee:
      compile:
        files:
          './public/assets/application.js': 'app/assets/scripts/**/*.coffee'


  grunt.registerTask('test', 'mochaTest')
  grunt.registerTask('newTest', 'newer:mochaTest')
