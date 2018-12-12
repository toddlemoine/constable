defmodule Constable.SubscriptionTest do
  use Constable.ModelCase

  alias Constable.Subscription

  describe ".subscribed?/2" do
    test "returns true when user is subscribed" do
      announcement = insert(:announcement)

      user =
        insert(:user)
        |> with_subscription(announcement)

      assert Subscription.subscribed?(user, announcement) == true
    end

    test "returns false when user is not subscribed" do
      announcement = insert(:announcement)
      user = insert(:user)

      assert Subscription.subscribed?(user, announcement) == false
    end
  end
end
