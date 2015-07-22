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

  it "has an /rssFeeds route" do
    get "/rssFeeds"
    expect(last_response).to be_ok
  end

  it "has a bookmarklet" do
    get "/marklet.js"
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

  it "searches" do
    get "/searches?q=/test"
    expect(last_response).to be_ok
  end

  it "shows captured pages" do
    get "/captures"
    expect(last_response).to be_ok
  end

  it "shows recent articles" do
    get "/recents"
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

  it "redirects click" do
    get "/redirect?url=http://example.com"
    expect(last_response).to be_redirect
  end

  it "renders app.js" do
    get "/app.js"
    expect(last_response).to be_ok
  end

  it "has a click history" do
    get "/clicks" 
    expect(last_response).to be_ok
  end

  it "has gets random articles" do
    get "/randoms" 
    expect(last_response).to be_ok
  end
end
