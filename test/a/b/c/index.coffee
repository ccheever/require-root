requireRoot = require('../../../../index')

requireExample = requireRoot("example")
requireExample2 = requireRoot("example2")

console.log("example#my-module", requireExample("my-module"))
console.log("example2#my-module", requireExample2("my-module"))

