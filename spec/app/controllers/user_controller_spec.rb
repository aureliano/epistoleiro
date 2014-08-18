require 'spec_helper'

describe "UserController" do
  
  it "creates an account" do
    post :create_account
    expect(last_response.body).to eq "Forbidden"
  end

end