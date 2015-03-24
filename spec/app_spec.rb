require 'spec_helper'

describe 'Pigeon' do
  it "should allow access to the home page" do
    get "/"
    expect(last_response).to be_redirect
  end

  it "should allow access to the home page" do
    get "/index.html"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Pigeon/)
  end

  it "has a /sources route" do
    get "/sources"
    expect(last_response).to be_ok
  end

#  it "has a /sources/new route" do
#    get "/sources/new"
#    expect(last_response).to be_ok
#    expect(last_response.body).to match(/Pigeon/)
#  end

  it "has a /sources/:id/articles route" do
    get "/sources/1/articles"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/1/)
  end

  it "has a /sources/:id route" do
    get "/sources/1"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/1/)
  end

  it "has a route for a single source" do
    get "/sources/1"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/1/)
  end

  it "redirects for searches with / as first character" do
    get "/search?q=/test"
    expect(last_response).to be_ok
  end

  it "searches" do
    get "/search"
    expect(last_response).to be_ok
  end

  it "shows recent articles" do
    get "/articles/recent"
    expect(last_response).to be_ok
  end

  it "has a marklet route" do
    get "/marklet.js"
    expect(last_response).to be_ok
  end
  
  it "has a bookmark route" do
    get "/bookmark/new"
    expect(last_response).to be_ok
  end

  it "has a stats route" do
    get "/stats"
    expect(last_response).to be_ok
  end
end
