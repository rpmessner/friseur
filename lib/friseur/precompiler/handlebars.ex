defmodule Friseur.Precompiler.Ember do
  use Friseur.Precompiler

  source "ember_precompiler.js"
  source "handlebars/dist/handlebars.js"
  source "ember/dist/ember-template-compiler.js"
end
