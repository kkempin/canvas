defmodule CanvasWeb.DrawingOperationControllerTest do
  use CanvasWeb.ConnCase

  alias Canvas.CanvasService

  @create_attrs %{
    fill_char: "a",
    height: 42,
    operation: "Rectangle",
    outline_char: "x",
    width: 42,
    x: 42,
    y: 42
  }

  @invalid_attrs %{
    fill_char: nil,
    height: nil,
    operation: nil,
    outline_char: nil,
    width: nil,
    x: nil,
    y: nil
  }

  setup %{conn: conn} do
    {:ok, canvas} = CanvasService.create_canvas(%{})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), canvas: canvas}
  end

  describe "create drawing_operation" do
    test "renders drawing_operation when data is valid", %{conn: conn, canvas: canvas} do
      attrs = Map.merge(@create_attrs, %{canvas_id: canvas.id})
      conn = post(conn, Routes.drawing_operation_path(conn, :create), draw: attrs)

      response = json_response(conn, 201)
      id = response["id"]

      assert response == %{
               "id" => id,
               "fill_char" => "a",
               "height" => 42,
               "operation" => "Rectangle",
               "outline_char" => "x",
               "width" => 42,
               "x" => 42,
               "y" => 42,
               "canvas_id" => canvas.id
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.drawing_operation_path(conn, :create), draw: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
