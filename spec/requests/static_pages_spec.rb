require 'spec_helper'

describe "StaticPages" do
  describe "GET /static_pages" do
    it "get root" do
      get root_path
      response.status.should be(200)
    end

    it "get /signin" do
      get signin_path
      response.status.should be(200)
    end

    it "get /signout" do
      delete signout_path
      response.status.should be(200)
    end

    it "get /signup" do
      get signup_path
      response.status.should be(200)
    end

  end
end
