var Friseur = {
  precompile: function(source) {
    return CoffeeScript.compile(source).toString();
  }
};
