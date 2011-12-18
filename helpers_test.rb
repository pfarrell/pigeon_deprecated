%w(helpers test/unit).each { |dependency| require dependency }

class HelpersTest < Test::Unit::TestCase
	def test_random_alpha_default
    assert_equal(String.random_alphanumeric().length, 16)
  end

	def test_random_alphanumeric_neg1
    assert_equal(String.random_alphanumeric(-1).length, 0)
  end

	def test_random_alphanumeric_neg2
    assert_equal(String.random_alphanumeric(-10).length, 0)
  end

	def test_random_alphanumeric_0
    assert_equal(String.random_alphanumeric(0).length, 0)
  end

	def test_random_alphanumeric_1
    assert_equal(String.random_alphanumeric(1).length, 1)
  end

	def test_random_alphanumeric_16
    assert_equal(String.random_alphanumeric(16).length, 16)
  end

	def test_random_alphanumeric_32
    assert_equal(String.random_alphanumeric(32).length, 32)
  end

	def test_random_alphanumeric_255
    assert_equal(String.random_alphanumeric(255).length, 255)
  end

	def test_random_alphanumeric
    assert_equal(String.random_alphanumeric(1024).length, 1024)
  end

	def test_random_alphanumeric_10000
    assert_equal(String.random_alphanumeric(10000).length, 10000)
	end

	def test_find_links_simple
    assert_equal(find_links("http://patf.net").length, 1)
	end

	def test_find_links_text1
    assert_equal(find_links("lorem ipsum http://patf.net lorem ipsum").length, 1)
	end

	def test_find_links_single_find
    assert_equal(find_links("http://patf.net http://patf.net").length, 1)
	end

	def test_find_links_find2
    assert_equal(find_links("http://patf.net/ http://patf.net").length, 2)
	end

	def test_find_links_find3
    assert_equal(find_links("http://patf.net http://patf.net/ http://patf.net/index.html").length, 3)
	end

	def test_find_links_find3
    assert_equal(find_links("http://patf.net http://patf.net/ http://patf.net/index.html").length, 3)
	end

	def test_find_links_find4
    assert_equal(find_links("there isn't much to see here: http://patf.net nor here http://patf.net/ likewise here http://patf.net/index.html however, http://37signals.com is another story").length, 4)
	end

	def test_find_links_find4_ignore1
    assert_equal(find_links("http://www.w3.org there isn't much to see here: http://patf.net nor here http://patf.net/ likewise here http://patf.net/index.html however, http://37signals.com is another story").length, 4)
	end

  def test_random_dir
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_1
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_2
    assert_equal(random_dir('test').length, 21)
  end

  def test_random_dir_3
    assert_equal(random_dir('').length, 18)
  end

  def test_random_dir_4
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_5
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_6
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_7
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_8
    assert_equal(random_dir('.').length, 18)
  end

  def test_random_dir_9
    assert_equal(random_dir('.').length, 18)
  end

end
