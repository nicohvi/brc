module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-newer')
  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.initConfig
    mochaTest:
      unit:
        options:
          reporter: 'spec',
          require: 'coffee-script/register',
          log: true
        src: ['test/**/*.coffee', '!test/integration/**/*.coffee']
      integration:
        options:
          require: 'coffee-script/register',
          log: true
        src: 'test/integration/**/*.coffee'
    watch:
      coffee:
        files: ['app/models/*.coffee', 'config/*.coffee']
        tasks: ['test']
      test:
        files: ['test/**/*.coffee', '!test/integration/**/*.coffee']
        tasks: ['newTest']
    coffee:
      compile:
        files:
          './public/assets/application.js': 'app/assets/scripts/**/*.coffee'


  grunt.registerTask('test', 'mochaTest:unit')
  grunt.registerTask('newTest', 'newer:mochaTest:unit')
  grunt.registerTask('integrate', 'mochaTest:integration')
