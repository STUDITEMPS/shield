defmodule Shield.Factory do
  @moduledoc """
  Generates factories
  """

  @repo Application.get_env(:authable, :repo)
  @resource_owner Application.get_env(:authable, :resource_owner)
  @token_store Application.get_env(:authable, :token_store)
  @client Application.get_env(:authable, :client)
  @app Application.get_env(:authable, :app)

  use ExMachina.Ecto, repo: @repo

  def user_factory do
    %@resource_owner{
      email: sequence(:email, &"foo-#{&1}@example.com"),
      password: Comeonin.Bcrypt.hashpwsalt("12345678"),
      settings: %{confirmed: true}
    }
  end

  def client_factory do
    %@client{
      name: sequence(:name, &"client#{&1}"),
      secret: SecureRandom.urlsafe_base64,
      redirect_uri: "https://example.com/oauth2-redirect-path",
      settings: %{
        name: "example",
        icon: "https://example.com/icon.png"
      }
    }
  end

  def confirmation_token_factory do
    %@token_store{
      name: "confirmation_token",
      value: sequence(:value, &"st#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600
    }
  end

  def reset_token_factory do
    %@token_store{
      name: "reset_token",
      value: sequence(:value, &"st#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600
    }
  end

  def session_token_factory do
    %@token_store{
      name: "session_token",
      value: sequence(:value, &"st#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{scope: "session,read,write"}
    }
  end

  def access_token_factory do
    %@token_store{
      name: "access_token",
      value: sequence(:value, &"at#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{
        scope: "read",
        grant_type: "authorization_code",
      }
    }
  end

  def refresh_token_factory do
    %@token_store{
      name: "refresh_token",
      value: sequence(:value, &"rt#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{
        grant_type: "authorization_code",
        scope: "read"
      }
    }
  end

  def authorization_code_factory do
    %@token_store{
      name: "authorization_code",
      value: sequence(:value, &"ac#{&1}"),
      expires_at: :os.system_time(:seconds) + 900,
      details: %{
        scope: "read",
        grant_type: "password",
      }
    }
  end

  def app_factory do
    %@app{
      scope: "read,write"
    }
  end
end
