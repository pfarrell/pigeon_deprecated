require 'spec_helper'

describe 'Pigeon' do
  it "should allow access to the home page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "has a /sources route" do
    get "/sources"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "has a /source/new route" do
    get "/source/new"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "has a route for a single source" do
    get "/source/1"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "redirects for searches with / as first character" do
    get "/search?q=/test"
    expect(last_response).to be_redirect
  end

  it "searches" do
    get "/search"
    expect(last_response).to be_ok
  end
end
