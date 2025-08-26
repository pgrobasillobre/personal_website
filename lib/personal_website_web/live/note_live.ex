defmodule PersonalWebsiteWeb.NoteLive do
  use PersonalWebsiteWeb, :live_view
  alias PersonalWebsite.Content

  def mount(%{"slug" => slug}, _session, socket) do
    case Content.get("notes", slug) do
      nil  -> {:ok, assign(socket, :note, nil)}
      note -> {:ok, assign(socket, :note, note)}
    end
  end

  def render(%{note: nil} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <h1 class="text-2xl font-semibold mb-4">Note not found</h1>
      <p><a class="underline" href={~p"/notes"}>Back to notes</a></p>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <p class="text-sm text-gray-600">
        <%= if @note.date, do: Date.to_iso8601(@note.date) %>
      </p>
      <h1 class="text-3xl font-semibold mb-4"><%= @note.title %></h1>
      <div class="max-w-none" dangerously_set_inner_html={@note.html}></div>
    </div>
    """
  end
end
