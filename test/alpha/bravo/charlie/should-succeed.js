requireRoot = require('../../../../index')

requireExample = requireRoot('bravo');
foundme = requireExample('foundme');
if (foundme.success == true) {
  console.log("ok :)");
} else {
  console.error("problem :(");
}

