defmodule Relx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Relx.Repo,
      %{id: Relx.Mail, start: {:gen_smtp_server, :start, [Relx.Mail]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Relx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
