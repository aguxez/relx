defmodule Relx.Mail do
  @moduledoc false

  @behaviour :gen_smtp_server_session

  alias Relx.Proxies
  alias Relx.Proxy
  alias Relx.Users
  alias Relx.User

  require Logger

  @env Application.compile_env!(:relx, :env)

  @impl true
  def init(hostname, _session_count, _address, opts) do
    {:ok, [hostname, " Relx ESMTP"], %{opts: opts}}
  end

  @impl true
  def handle_HELO(_hostname, state) do
    {:ok, state}
  end

  @impl true
  def handle_EHLO(_hostname, extensions, state) do
    {:ok, extensions, state}
  end

  @impl true
  def handle_MAIL(_from, state) do
    # TODO: Handle blacklists
    {:ok, state}
  end

  @impl true
  def handle_MAIL_extension(_extension, state) do
    {:ok, state}
  end

  @impl true
  def handle_RCPT(to, state) do
    case Proxies.get_by_email(to) do
      %Proxy{is_enabled: true} = proxy -> {:ok, Map.put(state, :proxy, proxy)}
      _ -> {:error, "550 no such recipient", state}
    end
  end

  @impl true
  def handle_RCPT_extension(_extension, state) do
    {:ok, state}
  end

  @impl true
  def handle_DATA(_from, _to, <<>>, state) do
    {:error, "552 Message too small", state}
  end

  # we're only handling a single recpt right now so we're going to pattern match for one
  def handle_DATA(from, [_recipient], data, state) do
    #  The `from` address is not important for fetching, we need to get a user from a proxy that
    # we should have in the state.
    case Users.get_by_id(state.proxy.user_id) do
      %User{email: user_email} ->
        [_, host] = String.split(user_email, "@", parts: 2)
        relay(from, user_email, data, host)

        Logger.info("Relaying email to #{user_email} through proxy #{state.proxy.email}")

        {:ok, "queued", state}

      _ ->
        {:error, "invalid proxy to user", state}
    end
  end

  defp relay(from, email, data, host) do
    :gen_smtp_client.send({from, [email], :erlang.binary_to_list(data)}, pick_host(host))
  end

  defp pick_host(host) do
    if @env != :prod,
      do: [relay: "0.0.0.0", port: 2525],
      else: [relay: host, port: 587]
  end

  @impl true
  def handle_RSET(state) do
    state
  end

  @impl true
  def handle_VRFY(_address, state) do
    {:error, "252 VRFY disabled, send mail only", state}
  end

  @impl true
  def handle_other(_verb, _args, state) do
    {"500 Error: command not recognized", state}
  end

  @impl true
  def handle_STARTTLS(state) do
    state
  end

  @impl true
  def code_change(_vsn, state, _extra), do: {:ok, state}

  @impl true
  def terminate(reason, state) do
    {:ok, reason, state}
  end
end
