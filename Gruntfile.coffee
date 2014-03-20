module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register'
        src: ['test/*.coffee']
    watch:
      coffee:
        files: ['*.coffee', 'app/models/*.coffee']
        tasks: ['test']
      test:
        files: ['test/*.coffee']
        tasks: ['test']


  grunt.registerTask('test', 'mochaTest')
