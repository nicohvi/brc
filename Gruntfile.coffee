module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-newer')

  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register',
          log: true
        src: ['test/*.coffee']
    watch:
      coffee:
        files: ['*.coffee', 'app/models/*.coffee', 'config/*.coffee']
        tasks: ['test']
      test:
        files: ['test/*.coffee']
        tasks: ['test']


  grunt.registerTask('test', 'newer:mochaTest')
