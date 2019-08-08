require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    User.create(
      email: "ahle@fakesite.com",
      password: "strong_password")
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_length_of(:password).is_at_least(6) } 

  it "creates a password digest when a password is given" do 
    expect(user.password_digest).to_not be_nil
  end 

  it "creates a session token before validation" do
    user.valid?
    expect(user.session_token).to_not be_nil
  end

  describe "#reset_session_token!" do
    it "sets a new session token on the user" do
      user.valid?
      old_session_token = user.session_token
      user.reset_session_token!

      expect(user.session_token).to_not eq(old_session_token)
    end

    it "returns the new session token" do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe "#password=" do
    it "encrypts the password with BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      User.new(email:'aleathere@gmail.com', password:'goodpassword')
    end

    it "verifies a password is not correct" do
      expect(user.is_password?("bad_password")).to be false
    end
  end
end
