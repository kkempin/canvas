defmodule CanvasWeb.DrawingOperationView do
  use CanvasWeb, :view

  def render("drawing_operation.json", %{drawing_operation: drawing_operation}) do
    %{
      id: drawing_operation.id,
      x: drawing_operation.x,
      y: drawing_operation.y,
      width: drawing_operation.width,
      height: drawing_operation.height,
      operation: drawing_operation.operation,
      fill_char: drawing_operation.fill_char,
      outline_char: drawing_operation.outline_char,
      canvas_id: drawing_operation.canvas_id
    }
  end
end
