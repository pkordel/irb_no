require 'spec_helper'

describe User do
  subject { User.create! email: "test@example.com", password: "secret", password_confirmation: "secret" }

  it "saves the current time the password reset was sent" do
    Timecop.freeze
    subject.send_reset_password_instructions
    subject.reset_password_sent_at.should eq(Time.zone.now)
  end

end
