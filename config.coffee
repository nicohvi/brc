module.exports = {

  debug: true
  secret_key: 'troll dog'

  database:
    adapter: 'postgres'
    name: 'brc_dev'
    username: 'postgres'
    port: 5432

  dev:
    port: process.env.PORT || 8000

  prod:
    port: process.env.PORT || 1069

  redis:
     host: 'localhost'
     port: 6379
     username: ''
     password: ''

}
