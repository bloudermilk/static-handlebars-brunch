# static-handlebars-brunch

static-handlebars-brunch is a Brunch plugin that facilitates the use of
Handlebars as a build-time templating engine. This is useful if you have many
"static" pages that need the ability to include partials or other dynamic
content at build time.

## How it works

Any `.hbs` file found in `app/templates` will be compiled to `.html` and copied
into `app/assets`. Brunch will then copy `app/assets` to `public`.

## Partials

A partial is any `.hbs` file in `app/templates` that begins with an underscore,
for example: `app/templates/_header.hbs`.

You can use the standard Handlebars partial helper to include partials in a
template:

```handlebars
{{> header}}

<p>This is a page!</p>

{{> footer}}
```

A custom partial helper is available which allows you to pass variables to your
partials.

## TODO

This library has a long way to go in terms of configurability and compatability
with other workflows. The following are known features which we would like to
support. Feel free to send a pull request if you end up implementing any.

* Support a custom source path (ie. `app/templates`).
* Support a custom compilation path (ie. `app/assets`).
* Play nicely with `handlebars-brunch` (ie. figure out how to support both
  plugins in one app).
* Support custom extensions (only `.hbs` is supported now).
* Cache partials (right now partials are recompiled up every time a file is
  changed).
* Write tests
