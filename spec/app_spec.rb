require 'spec_helper'

describe 'Pigeon' do
  it "should allow access to the home page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "has a sources route" do
    get "/sources"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end
end
