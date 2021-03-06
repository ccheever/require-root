## 
# A utility for making dealing with all the require paths
# a little easier in projects
#
# I'm not sure this is the best approach yet, but it seems 
# worth trying, and it should be easy enough to switch to something
# else later if that's better
#
##

fs = require 'fs'

_ROOTS = {}

findRoot = (rootName) ->
  """Finds the root for a given rootName; see requireRoot below"""

  relativePrefix = "./"
  loop
    rootPath = fs.realpathSync relativePrefix
    rootFile = "#{ rootPath }/#{ rootName }.root"
    if fs.existsSync rootFile
      break
    if rootPath == "/"
      throw new Error "Never found .root file for '#{ rootName }'"
    relativePrefix = "../" + relativePrefix

  contents = (fs.readFileSync rootFile).toString().trim()

  if contents.length > 0
    try
      fileData = JSON.parse contents
    catch e
      fileData = { rootPath: contents.trim() }

    if fileData.rootPath?

      if ((fileData.rootPath.charAt 0) == '/')
        # Absolute path
        rootPath = fs.realpathSync fileData.rootPath
      else
        # Relative path
        rootPath = fs.realpathSync rootPath + "/" + fileData.rootPath

  rootPath

requireRoot = (rootName) ->
  """Searches recursively up the directory structure of the filesystem
    looking for a file named <rootName>.root and when that is found, 
    establishes that directory as the root of <rootName>; this function
    then returns a wrapper around require that looks for things relative
    to that root directory

    Ex.
      requireRoot = require './require-root'
      requireMyProject = requireRoot 'my-project'
      model = requireMyProject 'model'

    The advantage of this is that you can move files around within a 
    project and not worry about trying to get the right number 
    of '../'s in front of your requires

    There doesn't seem to be a totally standard way of doing stuff
    like this in the Node community right now; everyone seems to roll
    their own.

    An alternative -- and perhaps quite sensible -- approach would be to
    look for a matching package.json file up the tree, but that would be 
    harder to implement and take more time (though that shouldn't really 
    matter)

    """

  # N.B.: It seems like its fine to use / as a path separator even
  # on Windows, so I don't think its necessary to do something like
  # require 'path' and then use path.sep
  # See: http://stackoverflow.com/questions/125813/how-to-determine-the-os-path-separator-in-javascript

  if not _ROOTS[rootName]?
    _ROOTS[rootName] = findRoot rootName
  rootPath = _ROOTS[rootName]
  
  rr = (m) ->
    #console.log "requiring", rootPath + "/" + m
    require rootPath + "/" + m

  rr.resolve = (m) ->
    """The analog of require.resolve for requireRoot"""

    require.resolve rootPath + "/" + m

  rr


requireRoot.__expose = 
  _ROOTS: _ROOTS
  findRoot: findRoot

module.exports = requireRoot

