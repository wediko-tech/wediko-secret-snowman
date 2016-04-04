require "spec_helper"

  RSpec.describe WishlistMailer, type: :mailer do
    class WishlistCreatedTest < ActionMailer::TestCase
    test "createdList" do
      # Send the email, then test that it got queued
      email = WishlistCreatedMailer.wish_list_creation_email('me@example.com').deliver_now
      assert_not ActionMailer::Base.deliveries.empty?

      # Test the body of the sent email contains what we expect it to
      assert_equal [ApplicationMailer.default[:from]], email.from
      # assert_equal ['friend@example.com'], email.to
      # assert_equal 'You have been invited by me@example.com', email.subject
      # assert_equal read_fixture('invite').join, email.body.to_s
    end
  end

    class WishlistItemPurchaseMailerTest < ActionMailer::TestCase
    test "bought" do
      # Send the email, then test that it got queued
      email = WishlistItemPurchaseMailer.item_purchased_email('me@example.com').deliver_now
      assert_not ActionMailer::Base.deliveries.empty?

      # Test the body of the sent email contains what we expect it to
      assert_equal [ApplicationMailer.default[:from]], email.from
      # assert_equal ['friend@example.com'], email.to
      # assert_equal 'You have been invited by me@example.com', email.subject
      # assert_equal read_fixture('invite').join, email.body.to_s
    end
  end
end
