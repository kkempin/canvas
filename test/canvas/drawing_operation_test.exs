defmodule Canvas.DrawingOperationTest do
  use Canvas.DataCase

  alias Canvas.DrawingOperation

  describe "validations" do
    test "operation, x and y are required" do
      invalid_changeset = DrawingOperation.changeset(%DrawingOperation{}, %{})

      refute invalid_changeset.valid?

      assert "can't be blank" in errors_on(invalid_changeset).operation
      assert "can't be blank" in errors_on(invalid_changeset).x
      assert "can't be blank" in errors_on(invalid_changeset).y
    end

    test "operation has to be either Rectangle or Flood fill" do
      invalid_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "something"})

      rectangle_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "Rectangle"})

      flood_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "Flood fill"})

      refute invalid_changeset.valid?
      assert "is invalid" in errors_on(invalid_changeset).operation

      refute Map.has_key?(errors_on(rectangle_changeset), :operation)
      refute Map.has_key?(errors_on(flood_changeset), :operation)
    end

    test "x and y has to be numbers greate or equal to 0" do
      invalid_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"x" => "-1", "y" => "s"})

      refute invalid_changeset.valid?

      assert "must be greater than or equal to 0" in errors_on(invalid_changeset).x
      assert "is invalid" in errors_on(invalid_changeset).y
    end

    test "width and height have to be numbers greater than 0 for Rectangle" do
      fill_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "Flood fill"})

      rectangle_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{
          "operation" => "Rectangle",
          "width" => "0",
          "height" => "s"
        })

      assert "is invalid" in errors_on(rectangle_changeset).height
      assert "must be greater than 0" in errors_on(rectangle_changeset).width

      refute Map.has_key?(errors_on(fill_changeset), :width)
      refute Map.has_key?(errors_on(fill_changeset), :height)
    end

    test "fill character has to be provided if operation is Flood fill" do
      invalid_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "Flood fill"})

      refute invalid_changeset.valid?

      assert "Fill char has to be provided." in errors_on(invalid_changeset).fill_char
    end

    test "fill or outline character has to be provided if operation is Rectangle" do
      invalid_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{"operation" => "Rectangle"})

      refute invalid_changeset.valid?

      assert "Fill or outline char has to be provided." in errors_on(invalid_changeset).fill_char
    end

    test "allows proper data for Rectangle" do
      rectangle_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{
          "operation" => "Rectangle",
          "x" => "10",
          "y" => "20",
          "width" => "4",
          "height" => "4",
          "fill_char" => "*"
        })

      assert rectangle_changeset.valid?
    end

    test "allows proper data for Flood fill" do
      fill_changeset =
        DrawingOperation.changeset(%DrawingOperation{}, %{
          "operation" => "Flood fill",
          "x" => "10",
          "y" => "20",
          "fill_char" => "*"
        })

      assert fill_changeset.valid?
    end
  end
end
