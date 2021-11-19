defmodule CanvasWeb.CanvasController do
  use CanvasWeb, :controller

  alias Canvas.{Canvas, CanvasService}

  action_fallback CanvasWeb.FallbackController

  def create(conn, %{"canvas" => canvas_params}) do
    with {:ok, %Canvas{} = canvas} <- CanvasService.create_canvas(canvas_params) do
      conn
      |> put_status(:created)
      |> render("canvas.json", canvas: canvas)
    end
  end
end
