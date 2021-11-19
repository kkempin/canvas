defmodule CanvasWeb.DrawingOperationController do
  use CanvasWeb, :controller

  alias Canvas.{DrawingOperation, DrawingService}

  action_fallback CanvasWeb.FallbackController

  def create(conn, %{"draw" => drawing_operation_params}) do
    with {:ok, %DrawingOperation{} = drawing_operation} <-
           DrawingService.create_drawing_operation(drawing_operation_params) do
      conn
      |> put_status(:created)
      |> render("drawing_operation.json", drawing_operation: drawing_operation)
    end
  end
end
