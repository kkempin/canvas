defmodule CanvasWeb.PageController do
  use CanvasWeb, :controller

  def index(conn, %{"id" => canvas_id}) do
    content = Canvas.CanvasService.render(canvas_id, "<br />")
    render(conn, "index.html", content: content, canvas_id: canvas_id)
  end
end
