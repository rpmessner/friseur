var compiled, window = {};
var Friseur = {
  precompile: function(source) {
    var parser = new(window.less.Parser)();
    parser.parse(source, function(err, tree) {
      compiled = err ? err.message + " line: " + err.line : tree.toCSS();
    });
    return compiled;
  }
};
