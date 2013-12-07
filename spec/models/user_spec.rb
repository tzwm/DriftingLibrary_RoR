require 'spec_helper'

describe User do

  before { @user = User.new(name: "test", email: "test@foo.bar", password: "44444444") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

end

