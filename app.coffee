# application entry point
exports.app = require('./server')(process.env.PORT || 8000, dev)
