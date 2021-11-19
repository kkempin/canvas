defmodule CanvasWeb.CanvasView do
  use CanvasWeb, :view
  alias CanvasWeb.CanvasView

  def render("canvas.json", %{canvas: canvas}) do
    %{
      id: canvas.id,
      content: canvas.content
    }
  end
end
