requireRoot = require('../../../../index')

requireExample = requireRoot('should-not-be-found')

console.log('example#my-module', requireExample('my-module'))
