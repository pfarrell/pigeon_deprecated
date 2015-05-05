module FixtureHelper

  def fixture_file(name)
    File.open("./spec/fixtures/#{name}")
  end

  def fixture_file_content(name)
    fixture_file(name).read
  end

  def node_from_fixture_file(name)
    html = fixture_file_content(name)
    Nokogiri.HTML(html)
  end

  def stub_image_request(url, length)
    stub_request(:head, url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {'Content-Length'=>length})
  end

end
