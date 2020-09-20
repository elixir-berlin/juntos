defmodule JuntosWeb.LoginComponent do
  @moduledoc false
  use Surface.LiveComponent

  property return_to, :string, required: true
  data header, :string, default: "Sign In"
  data alternative_text, :string, default: "First time?"
  data alternative_link_text, :string, default: "Sign up"

  @impl true
  def render(assigns) do
    ~H"""
    <div id="sign-in" class="modal sign-in-up-modal" >
      <div class="modal-background" ></div>
      <div class="modal-content">
        <header>
          <div class="close-button-container"><button class="is-white mdi mdi-24px mdi-close modal-close-juntos close-button"></button></div>
          <div class="header-text" ><h6>{{ @header }}</h6></div>
        </header>
        <section class="modal-card-body">
          <div class="modal-subtitle">To RSVP events</div>
            <div class="identity-button-container">
              <button class="button identity-button" :on-phx-click="github">GITHUB</button>
            </div>
            <div class="more-text">{{ @alternative_text }} <a :on-phx-click="switch" onclick="function (e} { e.preventDefault()}">{{ @alternative_link_text }}</a></div>
        </section>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("github", _, socket) do
    user_return_to = socket.assigns.return_to

    auth_path =
      JuntosWeb.Router.Helpers.auth_provider_path(socket, :store_redirect_to, :github, %{
        user_return_to: user_return_to
      })

    {:noreply, push_redirect(socket, to: auth_path, replace: true)}
  end

  @impl true
  def handle_event("switch", %{}, %{assigns: %{header: "Sign In"}} = socket) do
    {:noreply,
     socket
     |> assign(:header, "Sign Up")
     |> assign(:alternative_text, "Already signed up?")
     |> assign(:alternative_link_text, "Sign in")}
  end

  @impl true
  def handle_event("switch", %{}, socket) do
    {:noreply,
     socket
     |> assign(:header, "Sign In")
     |> assign(:alternative_text, "First time?")
     |> assign(:alternative_link_text, "Sign up")}
  end
end
