require-root
============

A utility for dealing with relative require paths in a Node project

*Example usage*:


In the directory that you think of as the root of the code you are
writing, touch a file called <root-name>.root

In that directory or any directory under that directory (subdir,
subdir of a subdir, etc.), instead of doing something like this:

    myLib = require('../../myLib')

You can do

    // Assumes you `touch`ed example.root in the same dir as myLib.js
    requireExample = require('require-root')('example')
    myLib = requireExample('myLib')

And not worry about how far up the directory tree you need to go
or rewriting all your ../s if you move things around

Or instead of 

    myModelLib = require('../../model/myLib')

You can do

    requireExample = require('require-root')('example')
    myModelLib = requireExample('model/myLib') // './model/myLib' also fine


For more advanced usage, you can put JSON in your .root file instead of 
just leaving it empty, and configure where exactly the root is -- if 
it isn't just in the same directory as your .root file, ex.

    model.root:
        {"rootPath":"./model/"}

Or

    some-code-somewhere-totally-different-on-my-filesystem.root:
        {"rootPath":"/absolute/path/to/somewhere/totally/different"}

There is also an analog of require.resolve, so you can do
    
    requireExample = require('require-root')('example')
    pathToFile = requireExample.resolve('myLib')

There's no problem working with multiple require-resolves in the same
file. Ex.

    requireResolve = require('require-resolve')
    requireModel = requireResolve('model')
    requireView = requireResolve('view')
    requireController = requireResolve('controller')

The resolution and reading of the .root files is cached, and should
only have to happen once per require-resolve, so this shouldn't 
cause any performance problems under most circumstances.


*A more detailed, concrete example, (from the test/ directory of this package)*

Given a directory structure that looks like this:

    .
    └── alpha
        ├── bravo
        │   ├── charlie
        │   │   └── index.js
        │   ├── delta
        │   │   └── my-module.js
        │   ├── example2.root
        │   └── my-module.js
        ├── example.root
        └── my-module.js

when ./alpha/bravo/charlie/index.js

contains the code

    requireRoot = require('../../../../index')

    requireExample = requireRoot('example')
    requireExample2 = requireRoot('example2')

    console.log('example#my-module', requireExample('my-module'))
    console.log('example2#my-module', requireExample2('my-module'))
    console.log('example#bravo/my-module', requireExample('bravo/my-module'))

will result in this output:

    example#my-module { success: true }
    example2#my-module { moreSuccess: true }
    example#bravo/my-module { success3: true }

The data structures logged are the module.exports from
    ./alpha/my-module.js
    ./alpha/bravo/delta/my-module.js
    ./alpha/bravo/my-module.js
respectively


