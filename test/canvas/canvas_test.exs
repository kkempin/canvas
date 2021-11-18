defmodule Canvas.CanvasTest do
  use Canvas.DataCase

  alias Canvas.Canvas

  describe "validations" do
    test "validates content" do
      invalid_changeset = Canvas.changeset(%Canvas{}, %{})

      valid_changeset = Canvas.changeset(%Canvas{}, %{"content" => ["***"]})

      refute invalid_changeset.valid?
      assert valid_changeset.valid?
    end
  end
end
