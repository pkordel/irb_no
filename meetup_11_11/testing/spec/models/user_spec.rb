require 'spec_helper'

describe User do
  let(:bob) { User.create! email: "test@example.com", password: "secret", password_confirmation: "secret" }

  it "saves the current time the password reset was sent" do
    Timecop.freeze
    bob.send_reset_password_instructions
    bob.reset_password_sent_at.should eq(Time.zone.now)
  end

end
