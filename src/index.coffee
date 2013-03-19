handlebars = require("handlebars")
sysPath = require("path")
mkdirp = require("mkdirp")
fs = require("fs")
glob = require("glob")

module.exports = class StaticHandlebarsCompiler
  brunchPlugin: true
  type: "template"
  extension: "hbs"

  constructor: (@config) ->
    return

  withPartials: (callback) ->
    partials = {}

    glob "app/templates/_*.hbs", (err, files) =>
      files.forEach (file) ->
        name = sysPath.basename(file, ".hbs").substr(1)

        fs.readFile file, (err, data) ->
          partials[name] = data.toString()

          callback(partials) if Object.keys(partials).length == files.length

  compile: (data, path, callback) ->
    try
      basename = sysPath.basename(path, ".hbs")
      template = handlebars.compile(data)

      @withPartials (partials) =>
        html = template({}, partials: partials, helpers: @makeHelpers(partials))
        newPath = "app/assets" + path.slice(13, -4) + ".html"

        fs.writeFile newPath, html, (err) ->
          callback(err, null)

    catch err
      callback err, null



  makeHelpers: (partials) ->
    partial: (partial, options) ->
      new handlebars.SafeString(
        handlebars.compile(partials[partial])(options.hash)
      )
