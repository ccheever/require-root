require-root
============

A utility for dealing with relative require paths in a Node project

Example usage (in CoffeeScript):

      requireRoot = require './require-root'
      requireMyProject = requireRoot 'my-project'
      model = requireMyProject 'model'
