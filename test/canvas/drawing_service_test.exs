defmodule Canvas.DrawingServiceTest do
  use Canvas.DataCase

  alias Canvas.{DrawingOperation, DrawingService, Canvas, Repo}

  describe "drawing Rectangle" do
    setup do
      canvas =
        %Canvas{} |> Canvas.new_changeset(%{"width" => 10, "height" => 10}) |> Repo.insert!()

      {:ok, canvas: canvas}
    end

    test "draws rectangle without outline", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 0,
          "y" => 0,
          "width" => 3,
          "height" => 3,
          "fill_char" => "x",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "xxx       ",
               "xxx       ",
               "xxx       ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end

    test "draws rectangle without fill", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 0,
          "y" => 0,
          "width" => 3,
          "height" => 3,
          "outline_char" => "x",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "xxx       ",
               "x x       ",
               "xxx       ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end

    test "draws rectangle with fill and outline", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 1,
          "y" => 1,
          "width" => 4,
          "height" => 4,
          "outline_char" => "x",
          "fill_char" => "o",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "          ",
               " xxxx     ",
               " xoox     ",
               " xoox     ",
               " xxxx     ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end

    test "does not draw outside of the canvas", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 15,
          "y" => 15,
          "width" => 4,
          "height" => 4,
          "outline_char" => "x",
          "fill_char" => "o",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end

    test "draws only part with rectangle is bigger than canvas", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 8,
          "y" => 8,
          "width" => 10,
          "height" => 10,
          "outline_char" => "x",
          "fill_char" => "o",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          ",
               "        xx",
               "        xo"
             ]
    end

    test "draws on already covered canvas", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 1,
          "y" => 1,
          "width" => 3,
          "height" => 3,
          "fill_char" => "x",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      second_drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 2,
          "y" => 2,
          "width" => 3,
          "height" => 3,
          "outline_char" => "u",
          "operation" => "Rectangle"
        })

      {:ok, canvas} = DrawingService.draw(second_drawing_operation.id)

      assert canvas.content == [
               "          ",
               " xxx      ",
               " xuuu     ",
               " xuxu     ",
               "  uuu     ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end
  end

  describe "drawing Flood fill" do
    setup do
      canvas =
        %Canvas{} |> Canvas.new_changeset(%{"width" => 10, "height" => 10}) |> Repo.insert!()

      {:ok, canvas: canvas}
    end

    test "fills empty canvas", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 0,
          "y" => 0,
          "fill_char" => "x",
          "operation" => "Flood fill"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx",
               "xxxxxxxxxx"
             ]
    end

    test "does not fill empty rectangle", %{canvas: canvas} do
      canvas =
        canvas
        |> Canvas.update_changeset(%{
          "content" => [
            "          ",
            " xxxx     ",
            " x  x     ",
            " x  x     ",
            "xxxxxxxxxx",
            "x        x",
            "xxxxxxxxxx",
            "          ",
            "          ",
            "          "
          ]
        })
        |> Repo.update!()

      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 0,
          "y" => 0,
          "fill_char" => "-",
          "operation" => "Flood fill"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "----------",
               "-xxxx-----",
               "-x  x-----",
               "-x  x-----",
               "xxxxxxxxxx",
               "x        x",
               "xxxxxxxxxx",
               "          ",
               "          ",
               "          "
             ]
    end

    test "fills empty rectangle", %{canvas: canvas} do
      canvas =
        canvas
        |> Canvas.update_changeset(%{
          "content" => [
            "          ",
            " xxxxx    ",
            " x   x    ",
            " x   x    ",
            " xxxxx    ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          "
          ]
        })
        |> Repo.update!()

      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 3,
          "y" => 3,
          "fill_char" => "-",
          "operation" => "Flood fill"
        })

      {:ok, canvas} = DrawingService.draw(drawing_operation.id)

      assert canvas.content == [
               "          ",
               " xxxxx    ",
               " x---x    ",
               " x---x    ",
               " xxxxx    ",
               "          ",
               "          ",
               "          ",
               "          ",
               "          "
             ]
    end
  end

  describe "process unprocess drawing operations" do
    setup do
      canvas =
        %Canvas{} |> Canvas.new_changeset(%{"width" => 10, "height" => 10}) |> Repo.insert!()

      {:ok, canvas: canvas}
    end

    test "processes drawing operations without drawn_at date", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 1,
          "y" => 1,
          "width" => 3,
          "height" => 3,
          "fill_char" => "x",
          "operation" => "Rectangle"
        })

      :ok = DrawingService.process_drawing_operations()

      drawing_operation = Repo.get(DrawingOperation, drawing_operation.id)

      refute is_nil(drawing_operation.drawn_at)
    end

    test "does not processes drawing operations with drawn_at date", %{canvas: canvas} do
      drawing_operation =
        create_drawing_operations(canvas, %{
          "x" => 1,
          "y" => 1,
          "width" => 3,
          "height" => 3,
          "fill_char" => "x",
          "operation" => "Rectangle",
          "drawn_at" => "2021-11-19 12:00:00"
        })

      :ok = DrawingService.process_drawing_operations()

      drawing_operation = Repo.get(DrawingOperation, drawing_operation.id)

      assert drawing_operation.drawn_at == ~U[2021-11-19 12:00:00Z]
    end
  end

  defp create_drawing_operations(canvas, attrs) do
    attrs = Map.merge(attrs, %{"canvas_id" => canvas.id})

    %DrawingOperation{}
    |> DrawingOperation.changeset(attrs)
    |> Repo.insert!()
  end
end
