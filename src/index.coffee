handlebars = require("handlebars")
sysPath = require("path")
fs = require("fs")
glob = require("glob")
mkdirp = require("mkdirp")

module.exports = class StaticHandlebarsCompiler
  brunchPlugin: true
  type: "template"
  extension: "hbs"

  constructor: (@config) ->
    @outputDirectory = @config?.plugins?.staticHandlebars?.outputDirectory || 'public'

    # Load additional configuration / context from a project-specific file
    includeFile = @config?.plugins?.staticHandlebars?.includeFile
    if includeFile?
      absoluteFile = sysPath.join(sysPath.resolve('./'), includeFile)
      @extras = require(absoluteFile)

  withPartials: (callback) ->
    partials = {}
    errThrown = false

    glob "app/templates/_*.hbs", (err, files) =>
      if err?
        callback(err)
      else
        files.forEach (file) ->
          name = sysPath.basename(file, ".hbs").substr(1)

          fs.readFile file, (err, data) ->
            if err? and !errThrown
              errThrown = true
              callback(err)
            else
              partials[name] = data.toString()

              callback(null, partials) if Object.keys(partials).length == files.length

  compile: (data, path, callback) ->
    try
      basename = sysPath.basename(path, ".hbs")
      template = handlebars.compile(data)
      context = if @extras then @extras(handlebars) else {}

      @withPartials (err, partials) =>
        if err?
          callback(err)
        else
          html = template(context, partials: partials, helpers: @makeHelpers(partials))
          newPath = @outputDirectory + path.slice(13, -4) + ".html"

          mkdirp.sync(sysPath.dirname(newPath))

          fs.writeFile newPath, html, (err) ->
            callback(err, null)

    catch err
      callback err, null

  makeHelpers: (partials) ->
    partial: (partial, options) ->
      new handlebars.SafeString(
        handlebars.compile(partials[partial])(options.hash)
      )
