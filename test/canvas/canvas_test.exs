defmodule Canvas.CanvasTest do
  use Canvas.DataCase

  alias Canvas.Canvas

  describe "validations" do
    test "validates content when updating" do
      invalid_changeset = Canvas.update_changeset(%Canvas{}, %{})

      valid_changeset = Canvas.update_changeset(%Canvas{}, %{"content" => ["***"]})

      refute invalid_changeset.valid?
      assert valid_changeset.valid?
    end
  end

  describe "filling with default structure" do
    test "fills with default structure" do
      canvas = Canvas.new_changeset(%Canvas{}, %{"width" => 5, "height" => 5})

      content = get_field(canvas, :content)

      assert length(content) == 5
      assert content == ["     ", "     ", "     ", "     ", "     "]
    end
  end
end
