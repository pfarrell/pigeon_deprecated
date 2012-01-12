%w(./helpers test/unit).each { |dependency| require dependency }

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

  def test_wget_filename_1
    assert_equal(wget_filename('http://news.ycombinator.com/item?id=3349390'), 'item%3Fid%3D3349390.html')
  end

  def test_wget_filename_2
    assert_equal(wget_filename('http://blog.firsthand.ca/2011/10/rails-is-not-your-application.html'), '')
  end

  def test_wget_filename_3
    assert_equal(wget_filename('http://www.infoq.com/presentations/We-Really-Dont-Know-How-To-Compute'), '')
  end

  def test_wget_filename_4
		assert_equal(wget_filename('http://blog.fogus.me/2011/08/14/perlis-languages/'), '')
  end

  def test_wget_filename_5
		assert_equal(wget_filename('http://www.mandolincafe.com/cgi-bin/tab/searchdb.cgi?searchterm=jjgs'), '')
  end

  def test_wget_filename_6
		assert_equal(wget_filename('http://www.alincoln-library.com/abraham-lincoln-jokes.shtml'), '')
  end

  def test_wget_filename_7
		assert_equal(wget_filename('http://msdn.microsoft.com/en-us/magazine/cc164014.aspx'), '')
  end

  def test_wget_filename_8
		assert_equal(wget_filename('http://arstechnica.com/gadgets/news/2011/10/facebook-sees-600000-compromised-logins-per-day006-of-all-logins.ars'), '')
  end

  def test_wget_filename_9
		assert_equal(wget_filename('http://alternet.us.com/?p=1398'), '')
  end

  def test_wget_filename_10
		assert_equal(wget_filename('http://www.gamasutra.com/blogs/ChrisHildenbrand/20111027/8713/2D_Game_Art_For_Programmers__Part_3.php'), '')
  end

  def test_wget_filename_11
		assert_equal(wget_filename('http://www.cl.cam.ac.uk/teaching/1112/L100/introling.pdf'), '')
  end

  def test_wget_filename_12
		assert_equal(wget_filename('http://martinfowler.com/articles/lmax.html?t=1319912579'), '')
  end

  def test_wget_filename_13
		assert_equal(wget_filename('http://robonobo.com/'), '')
  end

  def test_wget_filename_14
		assert_equal(wget_filename('http://blog.mailgun.net/post/12482374892/handle-incoming-emails-like-a-pro-mailgun-api-2-0'), '')
  end

  def test_wget_filename_15
		assert_equal(wget_filename('http://www.newyorker.com/reporting/2011/11/14/111114fa_fact_gladwell?currentPage=all'), '')
  end

  def test_wget_filename_16
		assert_equal(wget_filename('http://www.jfsowa.com/logic/math.htm'), '')
  end

  def test_wget_filename_17
		assert_equal(wget_filename('http://queue.acm.org/detail.cfm?id=2068896'), '')
  end

  def test_wget_filename_18
		assert_equal(wget_filename('http://en.wikipedia.org/wiki/Parrondo%27s_paradox'), '')
  end

  def test_wget_filename_19
		assert_equal(wget_filename('http://www.nytimes.com/2011/11/20/business/after-law-school-associates-learn-to-be-lawyers.html?_r=2&ref=business&pagewanted=all'), '')
  end

  def test_wget_filename_20
		assert_equal(wget_filename('http://www.catonmat.net/download/perl1line.txt'), '')
  end

  def test_wget_filename_21
		assert_equal(wget_filename('http://www.ultimate-guitar.com/print.php/id1001463/?transpose=3D0'), '')
  end

  def test_wget_filename_22
		assert_equal(wget_filename('https://github.com/TTimo/doom3.gpl'), '')
  end

  def test_wget_filename_23
		assert_equal(wget_filename('http://introducinghtml5.com/'), '')
  end

  def test_wget_filename_24
		assert_equal(wget_filename('http://m.techcrunch.com/2011/11/23/marketing-software-giant-exacttarget-re-files-for-ipo-will-raise-100m/?icid=tc_home_art&'), '')
  end

  def test_wget_filename_25
		assert_equal(wget_filename('http://c2.com/cgi/wiki?SwitchStatementsSmell'), '')
  end

  def test_wget_filename_26
		assert_equal(wget_filename('http://twinpeaks.org/faqeps.htm#e5'), '')
  end

  def test_wget_filename_27
		assert_equal(wget_filename('http://regex.learncodethehardway.org/?'), '')
  end

  def test_wget_filename_28
		assert_equal(wget_filename('http://news.ycombinator.com/item?id=3D3349390</a></span>'), '')
  end
end
