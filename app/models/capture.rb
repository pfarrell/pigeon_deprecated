require 'cgi'

class Capture < Sequel::Model
  many_to_one :article

  def download!(dir=short_dir)
    raise "no associated article" if article.nil?
    system("wget -qnd -pHEKk --no-check-certificate --random-wait --timeout=60 -P public/sites/" + dir + " " + article.url)
    self.url = "sites/#{dir}/#{CGI.escapeHTML(clean(article.url))}"
    self.save
    dir
  end

  def short_dir(size=5)
    dir = random_alphanumeric(size)
    while directory_exists?("public/sites/#{dir}")
      dir = random_alphanumeric(size)
    end
    dir
  end

  def random_alphanumeric(size=16)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s
  end

  def clean(filename)
    retval = filename.split('/').last.gsub(/#.*/, "")

    #special case to handle test.html? which wget 
    #downloads as test.html
    if retval.match(/html\?$/)
      retval = retval.gsub(/\?$/, "")
    end

    if filename.match(/\/$/) || filename.match(/\/\?$/)
      retval = 'index.html'
    elsif filename.match(/\.html/) || filename.match(/pdf$/) || filename.match(/jp[e]?g$/) || filename.match(/gif$/)
      retval = CGI.escape(retval)
    else
      retval = CGI.escape(retval + '.html')
    end
    retval
  end

  def directory_exists?(directory)
    File.directory?(directory)
  end
end

