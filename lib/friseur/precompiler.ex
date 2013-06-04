defmodule Friseur.Precompiler.Macros do
  defmacro source(<<path::binary>>) do
    { :ok, source } = "../../javascripts/#{path}"
      |> Path.expand(__FILE__)
      |> File.read

    quote do
      @sources unquote(source)
    end
  end
end

defmodule Friseur.Precompiler do
  use Behaviour

  defmacro __before_compile__(_) do
    quote location: :keep do
      def sources do
        @sources || []
      end
    end
  end

  defmacro __using__(_) do
    setup =
      quote do
        use GenServer.Behaviour
        import Friseur.Precompiler.Macros
        Module.register_attribute __MODULE__, :sources, accumulate: true
        @before_compile unquote(__MODULE__)
      end

    definitions =
      quote location: :keep do
        def start do
          :gen_server.start({:local, __MODULE__}, __MODULE__, start_state, [])
        end

        def stop do
          :gen_server.call(__MODULE__, :stop)
        end

        def run(source) do
          :erlv8_vm.run(vm, source)
        end

        def vm do
          :gen_server.call(__MODULE__, :vm)
        end

        def global do
          :gen_server.call(__MODULE__, :global)
        end

        def get_value(source) do
          global.get_value(source)
        end

        def compile(<<source::binary>>) do
          precompile_function.call([source])
        end

        def handle_call(:stop, _from, state) do
          :erlv8_vm.stop(state[:vm])
          { :stop, :normal, :ok, state }
        end

        def handle_call(:global, _from, state) do
          { :reply, state[:global], state }
        end

        def handle_call(:vm, _from, state) do
          { :reply, state[:vm], state }
        end

        def start_state do
          { :ok, vm_pid } = :erlv8_vm.start
          global = vm_pid |> :erlv8_vm.global
          sources |> Enum.map(:erlv8_vm.run(vm_pid, &1))
          [vm: vm_pid, global: global]
        end

        def precompile_function do
          get_value("Friseur").get_value("precompile")
        end

        defp sanitize(<<source::binary>>) do
          source = Regex.replace(%r/\\n/, source, "\n")
          # source = Regex.replace(%r/\\["']/, source, "\"")
          source
        end
      end

    quote do
      unquote(setup)
      unquote(definitions)
    end
  end
end
