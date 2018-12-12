defmodule ConstableWeb.NewCommentTest do
  use ConstableWeb.AcceptanceCase

  test "new comments are displayed in real time", %{session: session} do
    {:ok, other_session} = Wallaby.start_session()
    [announcement, other_announcement] = insert_pair(:announcement)
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :show, announcement, as: user.id))
    |> fill_in(text_field("comment_body"), with: "My Cool Comment")
    |> click(button("Post Comment"))

    other_session
    |> visit(Routes.announcement_path(Endpoint, :show, other_announcement, as: user.id))

    assert has_comment_text?(session, "My Cool Comment")
    refute has_comment_text?(other_session, "My Cool Comment")
  end

  test "comment on announcement auto subscribes commenter", %{session: session} do
    announcement = insert(:announcement)
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :show, announcement, as: user.id))
    |> assert_has(subscription_text_displayed?("Subscribe to thread"))

    session
    |> fill_in(text_field("comment_body"), with: "My Cool Comment")
    |> click(button("Post Comment"))

    session
    |> visit(Routes.announcement_path(Endpoint, :show, announcement, as: user.id))
    |> assert_has(subscription_text_displayed?("Subscribed to thread"))
  end

  defp subscription_text_displayed?(text) do
    css(".subscription", text: text)
  end

  defp has_comment_text?(session, comment_text) do
    session
    |> find(css(".comments-list"))
    |> has_text?(comment_text)
  end
end
