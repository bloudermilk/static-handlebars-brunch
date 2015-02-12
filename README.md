# static-handlebars-brunch

static-handlebars-brunch is a Brunch plugin that facilitates the use of
Handlebars as a build-time templating engine. This is useful if you have many
"static" pages that need the ability to include partials or other dynamic
content at build time.

## Installation

`npm install --save static-handlebars-brunch`

This will add it to your package.json file and install the package automatically.


## How it works

Any `.hbs` file found in `app/templates` will be compiled to `.html` and copied
into `app/assets`. Brunch will then copy `app/assets` to `public`.

## Partials

A partial is any `.hbs` file in `app/templates` that begins with an underscore,
for example: `app/templates/_header.hbs`.

You can use the standard Handlebars partial helper to include partials in a
template:

```hbs
{{> header}}

<p>This is a page!</p>

{{> footer}}
```

A custom partial helper is available which allows you to pass variables to your
partials.

```hbs
{{partial "header" title="My great page"}}

<p>This is a page!</p>

{{> "footer"}}
```

## Configuration

### Output directory

You can customize the output directory (default: `app/assets`)

```coffee
exports.config =
  plugins:
    staticHandlebars:
      outputDirectory: 'app/another_directory'
```

### Additional project-specific configuration

You can set the context and configure Handlebars in your project by using an extra file (default: `./staticHandlebarsExtras.js` in your projects root directory).

```coffee
exports.config =
  plugins:
    staticHandlebars:
      includeFile: 'app/another_directory'
```

The file may look like this:
```coffee
/*
  Parameters:
  - handlebars -> reference to the handlebars object
  
  Returns:
  - context -> object which represents the context in which the templates will be executed
*/

module.exports = function(handlebars) {
  var context = {
    color: 'blue'
  };
  
  // make calls on the 'handlebars'-variable to define additional helpers etc.
  
  return context;
};
```

## TODO

This library has a long way to go in terms of configurability and compatability
with other workflows. The following are known features which we would like to
support. Feel free to send a pull request if you end up implementing any.

* Support a custom source path (ie. `app/templates`).
* Play nicely with `handlebars-brunch` (ie. figure out how to support both
  plugins in one app).
* Support custom extensions (only `.hbs` is supported now).
* Cache partials (right now partials are recompiled up every time a file is
  changed).
* Write tests

## Contribution

* Fork this repository
* Create a feature branch on your fork
* Recompile the coffeescript: `coffee -c -o lib/ src/index.coffee`
* Make a Pull Request

## License

static-handlebars-brunch is an open source project released under the MIT
License. See `MIT-LICENSE` in the project root for more details.
