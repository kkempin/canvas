defmodule CanvasWeb.PageController do
  use CanvasWeb, :controller

  alias Canvas.DrawingService

  def index(conn, %{"id" => canvas_id}) do
    content = DrawingService.render(canvas_id, "<br />")
    render(conn, "index.html", content: content, canvas_id: canvas_id)
  end
end
