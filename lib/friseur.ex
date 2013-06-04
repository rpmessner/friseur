defmodule Friseur do
  use GenServer.Behaviour

  def start do
    :application.start(:erlv8)
    Friseur.Precompiler.Ember.start
    Friseur.Precompiler.Coffeescript.start
    Friseur.Precompiler.LessCss.start
  end

  def stop do
    Friseur.Precompiler.Ember.stop
    Friseur.Precompiler.Coffeescript.stop
    Friseur.Precompiler.LessCss.stop
  end
end
