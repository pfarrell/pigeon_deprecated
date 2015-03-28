require './app'
require 'json'

lookup = {}
lookup["4f2ee4e8ed860767a8000008"]="Hacker News"
lookup["4f2f40faed86070b29000009"]="PandoDaily"
lookup["4f34135bed8607244e00028d"]="The Old New Thing"
lookup["4f341446ed8607244e00029c"]="Coding Horror"
lookup["4f341466ed8607244e0002a7"]="Signal vs. Noise"
lookup["4f341522ed8607244e0002bb"]="Rob Conery"
lookup["4f341569ed8607244e0002c8"]="John Resig"
lookup["4f341581ed8607244e0002d6"]="Scott Hanselman"
lookup["4f341eb4ed8607244e000416"]="CNN.com"
lookup["4f341ecfed8607244e000426"]="IndyStar - Top Stories"
lookup["4f341f0ced8607244e000449"]="BBC News - Home"
lookup["4f341f1ded8607244e00045b"]="BBC News - Science & Environment"
lookup["4f341f2ced8607244e00046e"]="BBC News - Technology"
lookup["4f3420dded8607244e000483"]="TechCrunch"
lookup["4f3420f2ed8607244e000498"]="TechCrunch » Fundings & Exits"
lookup["4f342173ed8607244e0004ae"]="ReadWriteWeb"
lookup["4f34222ded8607244e0004c5"]="reddit: Technology"
lookup["4f34229bed8607244e0004dd"]="reddit: the front page of the internet"
lookup["4f3428d3ed8607244e00054d"]="Tumblr: timfarrellnyc"
lookup["4f3433c8ed860728ae00001b"]="dzone.com: latest front page"
lookup["4f34344fed860728ae000036"]="Technology"
lookup["4f3434beed860728ae000052"]="design mind on GOOD"
lookup["4f3434e5ed860728ae00006f"]="pop smART"
lookup["4f343512ed860728ae00008d"]="Design"
lookup["4f343526ed860728ae0000ac"]="Lifestyle"
lookup["4f45398ced86072ccc0000e0"]="Lambda the Ultimate - Programming Languages Weblog"
lookup["4f46a006ed86070b090000cf"]="High Scalability"
lookup["4f47f078ed86077d6a000004"]="Programming in the 21st Century"
lookup["4f47f09aed86077d6a00002a"]="DailyJS"
lookup["4f47f0b0ed86077d6a00004e"]="Tom Preston-Werner"
lookup["4f4fcb67ed86075636000046"]="Signal vs. Noise"
lookup["4f4fcbc4ed8607563600006c"]="Dilbert Daily Strip"
lookup["4f4fcc37ed860756360000e3"]="Penny Arcade"
lookup["4f4fcc55ed8607563600010b"]="Saturday Morning Breakfast Cereal (updated daily)"
lookup["4f4fcc7ded86075636000134"]="xkcd.com"
lookup["4f50e8a2ed860756360003e2"]="erjjones's Activity"
lookup["4f50e8b2ed8607563600040d"]="pfarrell's Activity"
lookup["4f56e14ced860766e70000e5"]="MeFi Music"
lookup["4f56e1b8ed860766e7000112"]="MetaFilter"
lookup["4f70a449ed860720ec000041"]="I, Cringely"
lookup["4f75f806ed86075d300000be"]="Letters of Note"
lookup["4f75f82ced86075d300000ee"]="Gödel's Lost Letter and P=NP"
lookup["4f7b060aed8607461f0000c6"]="John Graham-Cumming"
lookup["4f91a158ed8607452c000033"]="Data Mining: Text Mining, Visualization and Social Media"
lookup["4f96296fed860748c0000064"]="Nir and Far"
lookup["4fa02a68ed86076b560000de"]="Daring Fireball"
lookup["4fa17be7ed86073ab3000037"]="Beta List"
lookup["4fa2a20bed86073ab3000186"]="Stevey's Blog Rants"
lookup["4fa6d99fed860742ba000048"]="Jef Claes"
lookup["4faab07fed86073b33000069"]="The GitHub Blog"
lookup["4faab1f8ed86073b330000a2"]="The Endeavour"
lookup["4faab4feed86073b33000114"]="profserious"
lookup["4faab571ed86073b3300014f"]="Computational Complexity"
lookup["4faab58aed86073b3300018b"]="Daniel Lemire's blog"
lookup["4faab63aed86073b3300023d"]="Communications of the ACM: Data / Storage And Retrieval"
lookup["4faab652ed86073b3300027b"]="Communications of the ACM: Artificial Intelligence"
lookup["4faab66ded86073b330002ba"]="Communications of the ACM: Search"
lookup["4faab67eed86073b330002fa"]="Communications of the ACM: Theory"
lookup["4faab691ed86073b3300033b"]="Communications of the ACM: Human Computer Interaction"
lookup["4faab6d7ed86073b3300037e"]="Alan Winfield's Web Log"
lookup["4faab71ded86073b330003c1"]="Communications of the ACM: blog@CACM"
lookup["4faab72eed86073b33000406"]="Google Research"
lookup["4faac495ed86073b330005a6"]="Machine Learning (Theory)"
lookup["4faac4e6ed86073b330005ec"]="Embedded in Academia"
lookup["4faade85ed86073b330006ba"]="What's new"
lookup["4faadec3ed86073b33000702"]="tombone's blog"
lookup["4faadf3eed86073b33000793"]="Computer Science: Theory and Application"
lookup["4faadf6bed86073b330007dd"]="Papers in Computer Science"
lookup["4faadf84ed86073b33000828"]="Machine Learning"
lookup["4faadfb8ed86075e3300004d"]="Semantic Web: Triples all the way down"
lookup["4faadfd3ed86075e3300009a"]="Machine Learning"
lookup["4faae00fed86075e330000e8"]="MetaOptimize Q+A - machine learning, nlpp, ai, text analysis, information retrieval, search, data mining, statistical modeling, and data visualization"
lookup["4faae02aed86075e33000137"]="No Free Hunch"
lookup["4faae061ed86075e33000187"]="Reverse Engineering"
lookup["4faae0b6ed86075e3300027c"]="Types, typed programming, and static program analysis"
lookup["4faae0cded86075e330002ce"]="Matt Might's blog"
lookup["4faae0ffed86075e33000321"]="natural language processing blog"
lookup["4faae140ed86075e33000375"]="Math ∩ Programming"
lookup["4fc5200bed86076bf30000ee"]="The Naive Optimist"
lookup["501693b0ed8607234800005a"]="ProgrammableWeb"
lookup["5018393fed860723480001a1"]="Ray Wenderlich"
lookup["50856da9ed86070e9e000101"]="thoughts from the red planet"
lookup["5108541ded860755cb0000e5"]="Simply Statistics"
lookup["51114bbfed86075e2600005e"]="igvita.com"
lookup["5155c32bed860752a600005e"]="The Netflix Tech Blog"
lookup["5249a0d4ed86075419000123"]="Alex's Blog"
lookup["53275779ed860757e50000c8"]="FiveThirtyEightFiveThirtyEight | Features"
lookup["5331f49eed860730fa0000fd"]="PhraseologyProject.com Phrases"
lookup["533b12a8ed86070729000072"]="\nLamer News\n"
lookup["533b135fed860707290000d5"]="programming"
lookup["533cd1a5ed86070729000213"]="Ask a Mathematician / Ask a Physicist"
lookup["53fe2063ed860732c3000001"]="Google Poetics"
lookup["5400da30ed86074b48000001"]="Vox -  All"
lookup["54065808ed86074b48000002"]="Gabriel Weinberg's Blog"
lookup["540e9041ed86076619000001"]="Giant Robots Smashing Into Other Giant Robots"
lookup["54134e98ed86076619000002"]="Kartik Agaram"
lookup["5421f338ed86076619000003"]="Salon des Refusés"
lookup["54270d73ed860732b7000001"]="The Register"
lookup["5430c325ed86076646000001"]="cdixon tumblr"
lookup["547d6a0ced8607542d000001"]="@Strilanc - Craig Gidney's Blog"
lookup["547d6a11ed8607542d000002"]="@Strilanc - Craig Gidney's Blog"
lookup["54907ef5ed8607542d000003"]="HTMLGoodies.com: Your source for HTML, CSS, JavaScript and Web Development Tutorials and Primers!"
lookup["54907fe2ed8607542d000004"]="Daily Writing Tips"
lookup["549086c3ed8607542d000005"]="WIRED"
lookup["549086f8ed8607542d000006"]="MakeUseOf"
lookup["5490878bed8607542d000007"]="SimplyRecipes.com"
lookup["549087e7ed8607542d000008"]="Interesting Thing of the Day"
lookup["54908802ed8607542d000009"]="News"
lookup["5490882aed8607542d00000a"]="Arts & Life"
lookup["5490883ced8607542d00000b"]="All Things Considered"
lookup["5490886ced8607542d00000c"]="Author Interviews"
lookup["5490887ded8607542d00000d"]="Books"
lookup["54908af1ed8607542d00000e"]="HTML5Rocks"
lookup["54908b8ced8607542d00000f"]="The Quietus | All Articles"
lookup["54908bfbed8607542d000010"]="My Old Kentucky Blog"
lookup["5491ba04ed8607542d000011"]="zen habits"
lookup["549e5f62ed8607542d000012"]="flak rss"
lookup["54a75180ed86075ee1000001"]="Grumpy Gamer"
lookup["54b04d7ded8607100c000001"]="Changing Bits"
lookup["54b88279ed8607100c000002"]="Casey's Blog"
lookup["54c28bb3ed8607100c000003"]="Randal S. Olson"
lookup["54c84f7ced8607100c000004"]="YouTube Engineering and Developers Blog"
lookup["54cb6073ed8607100c000006"]="Code as Craft - Code as Craft"

def get_source(id)
  Source.find(title: lookup[id])
end

def save_file(dest, content)
  File.open(dest, "w") do |f|
    f.write(content)
  end
end

File.open(ARGV[0], "r") do |file_handle|
  cnt = 0 
  file_handle.each_line do |line|
    cnt +=1 

    print '.' if cnt % 500 == 0
    print "\n" if cnt % 10000 == 0
    hsh = JSON.parse(line)
    next if hsh['raw_content'].nil?
    article = Article.find(:url => hsh['remote_url'])
    next if article.nil? || article.id.nil?
    #puts hsh['raw_content']
    save_file("./html/#{article.id}.html", hsh['raw_content'])
  end 
  print "\n"
end
