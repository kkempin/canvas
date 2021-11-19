defmodule Canvas.CanvasServiceTest do
  use Canvas.DataCase

  alias Canvas.CanvasService

  describe "creating" do
    test "creates a canvas" do
      {:ok, canvas} = CanvasService.create_canvas(%{"width" => "2", "height" => "2"})

      assert canvas.width == 2
      assert canvas.height == 2
      assert canvas.content == ["  ", "  "]
    end

    test "returns errors if params are wrong" do
      {:error, errors} = CanvasService.create_canvas(%{"height" => "ww"})

      assert ["is invalid"] == errors_on(errors).height
    end
  end

  describe "updating" do
    setup do
      {:ok, canvas} = CanvasService.create_canvas(%{"width" => "2", "height" => "2"})

      {:ok, canvas: canvas}
    end

    test "updates a canvas", %{canvas: canvas} do
      {:ok, canvas} = CanvasService.update_canvas(canvas, %{"content" => [" ", " "]})

      assert canvas.width == 2
      assert canvas.height == 2
      assert canvas.content == [" ", " "]
    end

    test "returns errors if params are wrong", %{canvas: canvas} do
      {:error, errors} = CanvasService.update_canvas(canvas, %{"height" => "1", "content" => ""})

      assert ["can't be blank"] == errors_on(errors).content
    end
  end
end
