defmodule CanvasWeb.CanvasControllerTest do
  use CanvasWeb.ConnCase

  @create_attrs %{
    width: 5,
    height: 5
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create canvas" do
    test "renders canvas when data is valid", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :create), canvas: @create_attrs)
      response = json_response(conn, 201)

      assert response["content"] == ["     ", "     ", "     ", "     ", "     "]

      assert response["id"]
    end
  end
end
