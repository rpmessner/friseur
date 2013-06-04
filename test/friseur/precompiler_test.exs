Code.require_file "../test_helper.exs", __DIR__

defmodule PrecompilerTest do
  use ExUnit.Case

  setup_all do
    Friseur.start
    :ok
  end

  teardown_all do
    Friseur.stop
    :ok
  end

  test :returns_a_handlebars_template do
    assert_compile "Hello {{name}}", Friseur.Precompiler.Ember
    """
    <div class="calendar">
      <a {{action switchToNextYear target="view"}}>{{view.nextYear}}</a>
    </div>
    {{view Radium.RangeChangerView}}
    """
      |> assert_compile Friseur.Precompiler.Ember
  end

  test :compiles_a_coffeescript_file do
    assert_compile "a = 1", Friseur.Precompiler.Coffeescript
  """
  class Foo
    init: ->
      alert("hi")
  """
      |> assert_compile Friseur.Precompiler.Coffeescript
  end

  test :compiles_a_less_file do
    """
.transition(@transition) {
  -webkit-transition: @transition;
     -moz-transition: @transition;
       -o-transition: @transition;
          transition: @transition;
}
h1 { color: blue; }
.opacity(@opacity) {
  opacity: @opacity / 100;
  filter: ~"alpha(opacity=@{opacity})";
}

a {
  .transition(all 0.4s);
  &:hover {
    .opacity(70);
  }
}

// Selector interpolation only works in 1.3.1+. Try it!
@theGoodThings: ~".food, .beer, .sleep, .javascript";

@{theGoodThings} {
  font-weight: bold;
}
"""
    |> assert_compile Friseur.Precompiler.LessCss
  end

  defp assert_compile(<<source::binary>>, module) do
    result = source |> module.compile
    # IO.inspect (case result do
    #   {:throw, {:error, error } } -> error.proplist
    #   {:erlv8_object, _, _ } = object -> object.proplist
    #   <<result::binary>> -> result
    # end)
    refute {:throw, {:error, _ } } = result
    refute nil? result
  end

end
