<%inherit file="site.mako" />
<%def name="title()">Chapter 10: Screen Scraping by Brandon Rhodes</%def><%
    book_url = 'http://www.amazon.com/gp/product/1430230037/ref=as_li_ss_il?ie=UTF8&tag=letsdisthemat-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1430230037'
%><article><%self:filter chain="apress_fix, rst_syntax_highlight">
<div class="date">Foundations of Python Network Programming</div>
<h1 class="chaptitle">Screen Scraping with BeautifulSoup and lxml</h1>
<a class="image-reference" href="http://www.amazon.com/gp/product/1430230037/ref=as_li_ss_il?ie=UTF8&tag=letsdisthemat-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1430230037"><img border="0" src="http://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=1430230037&MarketPlace=US&ID=AsinImage&WS=1&tag=letsdisthemat-20&ServiceVersion=20070822" ></a>
<blockquote>
  Please enjoy this — a <b>free Chapter</b> of the
  <a href="http://www.amazon.com/gp/product/1430230037/ref=as_li_ss_il?ie=UTF8&tag=letsdisthemat-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1430230037"
     >Python network programming book</a>
  that I revised for Apress in 2010!<br>
  <br>
  I completely rewrote this chapter for the book's second edition,
  to feature two powerful libraries
  that have appeared since the book first came out.
  I show how to screen-scrape a real-life web page
  using both <b>BeautifulSoup</b>
  and also the powerful <b>lxml</b> library
  (their web sites are
  <a href="http://www.crummy.com/software/BeautifulSoup/">here</a>
  and
  <a href="http://lxml.de/">here</a>).<br>
  <br>
  I chose this chapter for release
  because screen scraping is often
  the first network task that a novice Python programmer tackles.
  Because this material is oriented towards beginners,
  it explains the entire process —
  from fetching web pages, to understanding HTML,
  to querying for specific elements in the document.<br>
  <br>
  Program listings are available for this chapter in both
  <a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10/"
       >Python 2</a> and also in
  <a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python3/10/"
       >Python 3</a>.
  Let me know if you have any questions!
</blockquote>
<p class="normal">Most web sites are designed first and foremost for human eyes. While well-designed sites offer formal APIs by which you can construct Google maps, upload Flickr photos, or browse YouTube videos, many sites offer nothing but HTML pages formatted for humans. If you need a program to be able to fetch its data, then you will need the ability to dive into densely formatted markup and retrieve the information you need&#8212;a process known affectionately as screen scraping.</p>
<p class="indent">In one&#39;s haste to grab information from a web page sitting open in your browser in front of you, it can be easy for even experienced programmers to forget to check whether an API is provided for data that they need. So try to take a few minutes investigating the site in which you are interested to see if some more formal programming interface is offered to their services. Even an RSS feed can sometimes be easier to parse than a list of items on a full web page.</p>
<p class="indent">Also be careful to check for a &#8220;terms of service&#8221; document on each site. YouTube, for example, offers an API and, in return, disallows programs from trying to parse their web pages. Sites usually do this for very important reasons related to performance and usage patterns, so I recommend always obeying the terms of service and simply going elsewhere for your data if they prove too restrictive.</p>
<p class="indent">Regardless of whether terms of service exist, always try to be polite when hitting public web sites. Cache pages or data that you will need for several minutes or hours, rather than hitting their site needlessly over and over again. When developing your screen-scraping algorithm, test against a copy of their web page that you save to disk, instead of doing an HTTP round-trip with every test. And always be aware that excessive use can result in your IP being temporarily or permanently blocked from a site if its owners are sensitive to automated sources of load.</p>
<h3 class="h3"><a id="fetching_web_pages" />Fetching Web Pages</h3>
<p class="normal">Before you can parse an HTML-formatted web page, you of course have to acquire some. <a href="${book_url}">Chapter 9</a> provides the kind of thorough introduction to the HTTP protocol that can help you figure out how to fetch information even from sites that require passwords or cookies. But, in brief, here are some options for downloading content.</p>

<div class="warning">
<p class="admonition-title">From the Future</p>
<p>
  If you need a simple way to fetch web pages before scraping them,
  try Kenneth Reitz's
  <tt><a href="http://docs.python-requests.org/en/latest/index.html"
         >requests</a></tt>
  library!
</p>
<p>
  The library was not released until after the book was published,
  but has already taken the Python world by storm.
  The simplicity and convenience of its API
  has made it the tool of choice for making web requests from Python.
</p>
</div>

<ul style="list-style-type:disc">
<li>You can use <code>urllib2</code>, or the even lower-level <code>httplib</code>, to construct an HTTP request that will return a web page. For each form that has to be filled out, you will have to build a dictionary representing the field names and data values inside; unlike a real web browser, these libraries will give you no help in submitting forms.</li>
<li>You can to install <code>mechanize</code> and write a program that fills out and submits web forms much as you would do when sitting in front of a web browser. The downside is that, to benefit from this automation, you will need to download the page containing the form HTML before you can then submit it&#8212;possibly doubling the number of web requests you perform!</li>
<li><a id="page_164" />If you need to download and parse entire web sites, take a look at the Scrapy project, hosted at <code><a href="http://scrapy.org">scrapy.org</a></code>, which provides a framework for implementing your own web spiders. With the tools it provides, you can write programs that follow links to every page on a web site, tabulating the data you want extracted from each page.</li>
<li>When web pages wind up being incomplete because they use dynamic JavaScript to load data that you need, you can use the <code>QtWebKit</code> module of the <code>PyQt4</code> library to load a page, let the JavaScript run, and then save or parse the resulting complete HTML page.</li>
<li>Finally, if you really need a browser to load the site, both the Selenium and Windmill test platforms provide a way to drive a standard web browser from inside a Python program. You can start the browser up, direct it to the page of interest, fill out and submit forms, do whatever else is necessary to bring up the data you need, and then pull the resulting information directly from the DOM elements that hold them.</li>
</ul>
<p class="indent">These last two options both require third-party components or Python modules that are built against large libraries, and so we will not cover them here, in favor of techniques that require only pure Python.</p>
<p class="indent">For our examples in this chapter, we will use the site of the United States National Weather Service, which lives at <code><a href="http://www.weather.gov/">www.weather.gov</a></code>.</p>
<p class="indent">Among the better features of the United States government is its having long ago decreed that all publications produced by their agencies are public domain. This means, happily, that I can pull all sorts of data from their web site and not worry about the fact that copies of the data are working their way into this book.</p>
<p class="indent">Of course, web sites change, so the <a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10">online source code</a> for this chapter includes the <a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10/phoenix.html">downloaded web page</a> on which the scripts in this chapter are designed to work. That way, even if their site undergoes a major redesign, you will still be able to try out the code examples in the future. And, anyway&#8212;as I recommended previously&#8212;you should be kind to web sites by always developing your scraping code against a downloaded copy of a web page to help reduce their load.</p>
<h3 class="h3"><a id="downloading_pages_through_form_submission" />Downloading Pages Through Form Submission</h3>
<p class="normal">The task of grabbing information from a web site usually starts by reading it carefully with a web browser and finding a route to the information you need. <a href="#fig_10_1">Figure 10&#8211;1</a> shows the site of the National Weather Service; for our first example, we will write a program that takes a city and state as arguments and prints out the current conditions, temperature, and humidity. If you will explore the site a bit, you will find that city-specific forecasts can be visited by typing the city name into the small &#8220;Local forecast&#8221; form in the left margin.</p>
<div id="fig_10_1" class="figure-contents">
<div class="mediaobject">
<a href="../images/nws.png"><img src="../images/1001.jpg" alt="Image" /></a>
</div>
</div>
<p class="normal"><a id="page_165" /><i><b>Figure 10&#8211;1.</b> The National Weather Service web site<br>(click to enlarge)</i></p>
<p class="indent">When using the <code>urllib2</code> module from the Standard Library, you will have to read the web page HTML manually to find the form. You can use the View Source command in your browser, search for the words &#8220;Local forecast,&#8221; and find the following form in the middle of the sea of HTML:</p>
<div class="pl">
<code>&lt;form method="post" action="http://forecast.weather.gov/zipcity.php" ...&gt;<br />
&#160;&#160;...<br />
&#160;&#160;&lt;input type="text" id="zipcity" name="inputstring" size="9"<br />
&#160;&#160;&#160;&#160;value="City, St" onfocus="this.value='';" /&gt;<br />
&#160;&#160;&lt;input type="submit" name="Go2" value="Go" /&gt;<br />
&lt;/form&gt;</code>
</div>
<p class="indent">The only important elements here are the <code>&lt;form&gt;</code> itself and the <code>&lt;input&gt;</code> fields inside; everything else is just decoration intended to help human readers.</p>
<p class="indent">This form does a <code>POST</code> to a particular URL with, it appears, just one parameter: an <code>inputstring</code> giving the city name and state. <a href="#list_10_1">Listing 10&#8211;1</a> shows a simple Python program that uses only the Standard Library to perform this interaction, and saves the result to <code>phoenix.html</code>.</p>
<div id="list_10_1" class="listing">
<p class="normal"><i><b>Listing 10&#8211;1.</b> Submitting a Form with &#8220;urllib2&#8221;</i></p>
<code>#!/usr/bin/env python<br />
# Foundations of Python Network Programming - Chapter 10 - fetch_urllib2.py<br />
# Submitting a form and retrieving a page with urllib2<br />
<br />
import urllib, urllib2</code><br />
<code><a id="page_166" />data = urllib.urlencode({'inputstring': 'Phoenix, AZ'})<br />
info = urllib2.urlopen('http://forecast.weather.gov/zipcity.php', data)<br />
content = info.read()<br />
open('phoenix.html', 'w').write(content)</code>
</div>
<p class="indent">On the one hand, <code>urllib2</code> makes this interaction very convenient; we are able to download a forecast page using only a few lines of code. But, on the other hand, we had to read and understand the form ourselves instead of relying on an actual HTML parser to read it. The approach encouraged by <code>mechanize</code> is quite different: you need only the address of the opening page to get started, and the library itself will take responsibility for exploring the HTML and letting you know what forms are present. Here are the forms that it finds on this particular page:</p>
<div class="pl">
<code>&gt;&gt;&gt; import mechanize<br />
&gt;&gt;&gt; br = mechanize.Browser()<br />
&gt;&gt;&gt; response = br.open('http://www.weather.gov/')<br />
&gt;&gt;&gt; for form in br.forms():<br />
...&#160;&#160;&#160;&#160;&#160;print '%r %r %s' % (form.name, form.attrs.get('id'), form.action)<br />
...&#160;&#160;&#160;&#160;&#160;for control in form.controls:<br />
...&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;print '&#160;&#160;&#160;', control.type, control.name, repr(control.value)<br />
None None http://search.usa.gov/search<br />
 &#160;&#160;&#160;hidden v:project 'firstgov'<br />
 &#160;&#160;&#160;text query ''<br />
 &#160;&#160;&#160;radio affiliate ['nws.noaa.gov']<br />
 &#160;&#160;&#160;submit None 'Go'<br />
None None http://forecast.weather.gov/zipcity.php<br />
 &#160;&#160;&#160;text inputstring 'City, St'<br />
 &#160;&#160;&#160;submit Go2 'Go'<br />
'jump' 'jump' http://www.weather.gov/<br />
 &#160;&#160;&#160;select menu ['http://www.weather.gov/alerts-beta/']<br />
 &#160;&#160;&#160;button None None</code>
</div>
<p class="indent">Here, <code>mechanize</code> has helped us avoid reading any HTML at all. Of course, pages with very obscure form names and fields might make it very difficult to look at a list of forms like this and decide which is the form we see on the page that we want to submit; in those cases, inspecting the HTML ourselves can be helpful, or&#8212;if you use Google Chrome, or Firefox with Firebug installed&#8212;right-clicking the form and selecting &#8220;Inspect Element&#8221; to jump right to its element in the document tree.</p>
<p class="indent">Once we have determined that we need the <code>zipcity.php</code> form, we can write a program like that shown in <a href="#list_10_2">Listing 10&#8211;2</a>. You can see that at no point does it build a set of form fields manually itself, as was necessary in our previous listing. Instead, it simply loads the front page, sets the one field value that we care about, and then presses the form&#39;s submit button. Note that since this HTML form did not specify a name, we had to create our own filter function&#8212;the lambda function in the listing&#8212;to choose which of the three forms we wanted.</p>
<div id="list_10_2" class="listing">
<p class="normal"><i><b>Listing 10&#8211;2.</b> Submitting a Form with <code>mechanize</code></i></p>
<code>#!/usr/bin/env python<br />
# Foundations of Python Network Programming - Chapter 10 - fetch_mechanize.py<br />
# Submitting a form and retrieving a page with mechanize<br />
<br />
import mechanize<br />
br = mechanize.Browser()<br />
br.open('http://www.weather.gov/')<br />
br.select_form(predicate=lambda(form): 'zipcity' in form.action)<br />
br['inputstring'] = 'Phoenix, AZ'<br />
response = br.submit()</code><br />
<code><a id="page_167" />content = response.read()<br />
open('phoenix.html', 'w').write(content)</code>
</div>
<p class="indent">Many <code>mechanize</code> users instead choose to select forms by the order in which they appear in the page&#8212;in which case we could have called <code>select_form(nr=1)</code>. But I prefer not to rely on the order, since the real identity of a form is inherent in the action that it performs, not its location on a page.</p>
<p class="indent">You will see immediately the problem with using <code>mechanize</code> for this kind of simple task: whereas <a href="#list_10_1">Listing 10&#8211;1</a> was able to fetch the page we wanted with a single HTTP request, <a href="#list_10_2">Listing 10&#8211;2</a> requires two round-trips to the web site to do the same task. For this reason, I avoid using <code>mechanize</code> for simple form submission. Instead, I keep it in reserve for the task at which it really shines: logging on to web sites like banks, which set cookies when you first arrive at their front page and require those cookies to be present as you log in and browse your accounts. Since these web sessions require a visit to the front page anyway, no extra round-trips are incurred by using <code>mechanize</code>.</p>
<h3 class="h3"><a id="the_structure_of_web_pages" />The Structure of Web Pages</h3>
<p class="normal">There is a veritable glut of online guides and published books on the subject of HTML, but a few notes about the format would seem to be appropriate here for users who might be encountering the format for the first time.</p>
<p class="indent">The Hypertext Markup Language (HTML) is one of many markup dialects built atop the Standard Generalized Markup Language (SGML), which bequeathed to the world the idea of using thousands of angle brackets to mark up plain text. Inserting bold and italics into a format like HTML is as simple as typing eight angle brackets:</p>
<div class="pl">
<code>The &lt;b&gt;very&lt;/b&gt; strange book &lt;i&gt;Tristram Shandy&lt;/i&gt;.</code>
</div>
<p class="indent">In the terminology of SGML, the strings <code>&lt;b&gt;</code> and <code>&lt;/b&gt;</code> are each tags&#8212;they are, in fact, an opening and a closing tag&#8212;and together they create an element that contains the text <code>very</code> inside it. Elements can contain text as well as other elements, and can define a series of key/value attribute pairs that give more information about the element:</p>
<div class="pl">
<code>&lt;p content="personal"&gt;I am reading &lt;i document="play"&gt;Hamlet&lt;/i&gt;.&lt;/p&gt;</code>
</div>
<p class="indent">There is a whole subfamily of markup languages based on the simpler Extensible Markup Language (XML), which takes SGML and removes most of its special cases and features to produce documents that can be generated and parsed without knowing their structure ahead of time. The problem with SGML languages in this regard&#8212;and HTML is one particular example&#8212;is that they expect parsers to know the rules about which elements can be nested inside which other elements, and this leads to constructions like this unordered list <code>&lt;ul&gt;</code>, inside which are several list items <code>&lt;li&gt;</code>:</p>
<div class="pl">
<code>&lt;ul&gt;&lt;li&gt;First&lt;li&gt;Second&lt;li&gt;Third&lt;li&gt;Fourth&lt;/ul&gt;</code>
</div>
<p class="indent">At first this might look like a series of <code>&lt;li&gt;</code> elements that are more and more deeply nested, so that the final word here is four list elements deep. But since HTML in fact says that <code>&lt;li&gt;</code> elements cannot nest, an HTML parser will understand the foregoing snippet to be equivalent to this more explicit XML string:</p>
<div class="pl">
<code>&lt;ul&gt;&lt;li&gt;First&lt;/li&gt;&lt;li&gt;Second&lt;/li&gt;&lt;li&gt;Third&lt;/li&gt;&lt;li&gt;Fourth&lt;/li&gt;&lt;/ul&gt;</code>
</div>
<p class="indent">And beyond this implicit understanding of HTML that a parser must possess are the twin problems that, first, various browsers over the years have varied wildly in how well they can reconstruct the document structure when given very concise or even deeply broken HTML; and, second, most web page authors judge the quality of their HTML by whether their browser of choice renders it correctly. This has resulted not only in a World Wide Web that is full of sites with invalid and broken HTML markup, but <a id="page_168" />also in the fact that the permissiveness built into browsers has encouraged different flavors of broken HTML among their different user groups.</p>
<p class="indent">If HTML is a new concept to you, you can find abundant resources online. Here are a few documents that have been longstanding resources in helping programmers learn the format:</p>
<div class="pl">
<code>www.w3.org/MarkUp/Guide/<br />
www.w3.org/MarkUp/Guide/Advanced.html<br />
www.w3.org/MarkUp/Guide/Style</code>
</div>
<p class="indent">The brief Bare Bones Guide, and the long and verbose HTML standard itself, are good resources to have when trying to remember an element name or the name of a particular attribute value:</p>
<div class="pl">
<code>http://werbach.com/barebones/barebones.html<br />
http://www.w3.org/TR/REC-html40/</code>
</div>
<p class="indent">When building your own web pages, try to install a real HTML validator in your editor, IDE, or build process, or test your web site once it is online by submitting it to</p>
<div class="pl">
<code>http://validator.w3.org/</code>
</div>
<p class="indent">You might also want to consider using the tidy tool, which can also be integrated into an editor or build process:</p>
<div class="pl">
<code>http://tidy.sourceforge.net/</code>
</div>
<p class="indent">We will now turn to that weather forecast for Phoenix, Arizona, that we downloaded earlier using our scripts (note that we will avoid creating extra traffic for the NWS by running our experiments against this local file), and we will learn how to extract actual data from HTML.</p>
<h3 class="h3"><a id="three_axes" />Three Axes</h3>
<p class="normal">Parsing HTML with Python requires three choices:</p>
<ul style="list-style-type:disc">
<li>The parser you will use to digest the HTML, and try to make sense of its tangle of opening and closing tags</li>
<li>The API by which your Python program will access the tree of concentric elements that the parser built from its analysis of the HTML page</li>
<li>What kinds of selectors you will be able to write to jump directly to the part of the page that interests you, instead of having to step into the hierarchy one element at a time</li>
</ul>
<p class="indent">The issue of selectors is a very important one, because a well-written selector can unambiguously identify an HTML element that interests you without your having to touch any of the elements above it in the document tree. This can insulate your program from larger design changes that might be made to a web site; as long as the element you are selecting retains the same ID, name, or whatever other property you select it with, your program will still find it even if after the redesign it is several levels deeper in the document.</p>
<p class="indent">I should pause for a second to explain terms like &#8220;deeper,&#8221; and I think the concept will be clearest if we reconsider the unordered list that was quoted in the previous section. An experienced web developer looking at that list rearranges it in her head, so that this is what it looks like:</p>
<div class="pl">
<code>&lt;ul&gt;<br />
&#160;&#160;&lt;li&gt;First&lt;/li&gt;<br />
&#160;&#160;&lt;li&gt;Second&lt;/li&gt;<br />
<a id="page_169" />&#160;&#160;&lt;li&gt;Third&lt;/li&gt;<br />
&#160;&#160;&lt;li&gt;Fourth&lt;/li&gt;<br />
&lt;/ul&gt;</code>
</div>
<p class="indent">Here the <code>&lt;ul&gt;</code> element is said to be a &#8220;parent&#8221; element of the individual list items, which &#8220;wraps&#8221; them and which is one level &#8220;above&#8221; them in the whole document. The <code>&lt;li&gt;</code> elements are &#8220;siblings&#8221; of one another; each is a &#8220;child&#8221; of the <code>&lt;ul&gt;</code> element that &#8220;contains&#8221; them, and they sit &#8220;below&#8221; their parent in the larger document tree. This kind of spatial thinking winds up being very important for working your way into a document through an API.</p>
<p class="indent">In brief, here are your choices along each of the three axes that were just listed:</p>
<ul style="list-style-type:disc">
<li>The most powerful, flexible, and fastest parser at the moment appears to be the <code>HTMLParser</code> that comes with <code>lxml</code>; the next most powerful is the longtime favorite BeautifulSoup (I see that its author has, in his words, &#8220;abandoned&#8221; the new 3.1 version because it is weaker when given broken HTML, and recommends using the 3.0 series until he has time to release 3.2); and coming in dead last are the parsing classes included with the Python Standard Library, which no one seems to use for serious screen scraping.</li>
<li>The best API for manipulating a tree of HTML elements is ElementTree, which has been brought into the Standard Library for use with the Standard Library parsers, and is also the API supported by <code>lxml</code>; BeautifulSoup supports an API peculiar to itself; and a pair of ancient, ugly, event-based interfaces to HTML still exist in the Python Standard Library.</li>
<li>The <code>lxml</code> library supports two of the major industry-standard selectors: CSS selectors and XPath query language; BeautifulSoup has a selector system all its own, but one that is very powerful and has powered countless web-scraping programs over the years.</li>
</ul>
<p class="indent">Given the foregoing range of options, I recommend using <code>lxml</code> when doing so is at all possible&#8212;installation requires compiling a C extension so that it can accelerate its parsing using <code>libxml2</code>&#8212;and using <code>BeautifulSoup</code> if you are on a machine where you can install only pure Python. Note that <code>lxml</code> is available as a pre-compiled package named <code>python-lxml</code> on Ubuntu machines, and that the best approach to installation is often this command line:</p>
<div class="pl">
<code>STATIC_DEPS=true pip install lxml</code>
</div>
<p class="indent">And if you consult the <code>lxml</code> documentation, you will find that it can optionally use the BeautifulSoup parser to build its own ElementTree-compliant trees of elements. This leaves very little reason to use BeautifulSoup by itself unless its selectors happen to be a perfect fit for your problem; we will discuss them later in this chapter.</p>
<p class="indent">But the state of the art may advance over the years, so be sure to consult its own documentation as well as recent blogs or Stack Overflow questions if you are having problems getting it to compile.</p>

<div class="warning">
  <p class="admonition-title">From the Future</p>
  <p>
    The
    <a href="http://www.crummy.com/software/BeautifulSoup/">BeautifulSoup</a>
    project has recovered!
    While the text below — written in late 2010 —
    has to carefully avoid the broken 3.2 release in favor of 3.0,
    BeautifulSoup has now released a rewrite named
    <a href="http://pypi.python.org/pypi/beautifulsoup4">beautifulsoup4</a>
    on the Python Package Index that works with both Python 2 and 3.
    Once installed, simply import it like this:
  </p>
  <p>
    <tt>from bs4 import BeautifulSoup</tt>
  </p>
  <p>
    I just ran a test,
    and it reads the malformed <tt>phoenix.html</tt> page perfectly.
  </p>
</div>

<h3 class="h3"><a id="diving_into_an_html_document" />Diving into an HTML Document</h3>
<p class="normal">The tree of objects that a parser creates from an HTML file is often called a Document Object Model, or DOM, even though this is officially the name of one particular API defined by the standards bodies and implemented by browsers for the use of JavaScript running on a web page.</p>
<p class="indent">The task we have set for ourselves, you will recall, is to find the current conditions, temperature, and humidity in the <code><a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10/phoenix.html">phoenix.html</a></code> page that we have downloaded. Here is an excerpt: <a href="#list_10_3">Listing 10&#8211;3</a>, which focuses on the pane that we are interested in.</p>
<div id="list_10_3" class="listing">
<p class="normal"><i><b>Listing 10&#8211;3.</b> Excerpt from the Phoenix Forecast Page</i></p>
<code>&lt;!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN"&gt;&lt;html&gt;&lt;head&gt;<br />
&lt;title&gt;7-Day Forecast for Latitude 33.45&amp;deg;N and Longitude 112.07&amp;deg;W (Elev. 1132 ft)&lt;/title&gt;&lt;link rel="STYLESHEET" type="text/css" href="fonts/main.css"&gt;<br />
...<br />
&lt;table cellspacing="0" cellspacing="0" border="0" width="100%"&gt;&lt;tr align="center"&gt;&lt;td&gt;&lt;table width='100%' border='0'&gt;<br />
&lt;tr&gt;<br />
&lt;td align ='center'&gt;<br />
&lt;span class='blue1'&gt;Phoenix, Phoenix Sky Harbor International Airport&lt;/span&gt;&lt;br&gt;<br />
Last Update on 29 Oct 7:51 MST&lt;br&gt;&lt;br&gt;<br />
&lt;/td&gt;<br />
&lt;/tr&gt;<br />
&lt;tr&gt;<br />
&lt;td colspan='2'&gt;<br />
&lt;table cellspacing='0' cellpadding='0' border='0' align='left'&gt;<br />
&lt;tr&gt;<br />
&lt;td class='big' width='120' align='center'&gt;<br />
&lt;font size='3' color='000066'&gt;<br />
A Few Clouds&lt;br&gt;<br />
&lt;br&gt;71&amp;deg;F&lt;br&gt;(22&amp;deg;C)&lt;/td&gt;<br />
&lt;/font&gt;&lt;td rowspan='2' width='200'&gt;&lt;table cellspacing='0' cellpadding='2' border='0' width='100%'&gt;<br />
&lt;tr bgcolor='#b0c4de'&gt;<br />
&lt;td&gt;&lt;b&gt;Humidity&lt;/b&gt;:&lt;/td&gt;<br />
&lt;td align='right'&gt;30 %&lt;/td&gt;<br />
&lt;/tr&gt;<br />
&lt;tr bgcolor='#ffefd5'&gt;<br />
&lt;td&gt;&lt;b&gt;Wind Speed&lt;/b&gt;:&lt;/td&gt;&lt;td align='right'&gt;SE 5 MPH&lt;br&gt;<br />
&lt;/td&gt;<br />
&lt;/tr&gt;<br />
&lt;tr bgcolor='#b0c4de'&gt;<br />
&lt;td&gt;&lt;b&gt;Barometer&lt;/b&gt;:&lt;/td&gt;&lt;td align='right' nowrap&gt;30.05 in (1015.90 mb)&lt;/td&gt;&lt;/tr&gt;<br />
&lt;tr bgcolor='#ffefd5'&gt;<br />
&lt;td&gt;&lt;b&gt;Dewpoint&lt;/b&gt;:&lt;/td&gt;&lt;td align='right'&gt;38&amp;deg;F (3&amp;deg;C)&lt;/td&gt;<br />
&lt;/tr&gt;<br />
&lt;/tr&gt;<br />
&lt;tr bgcolor='#ffefd5'&gt;<br />
&lt;td&gt;&lt;b&gt;Visibility&lt;/b&gt;:&lt;/td&gt;&lt;td align='right'&gt;10.00 Miles&lt;/td&gt;<br />
&lt;/tr&gt;<br />
&lt;tr&gt;&lt;td nowrap&gt;&lt;b&gt;&lt;a href='http://www.wrh.noaa.gov/total_forecast/other_obs.php?wfo=psr&amp;zone=AZZ023' class='link'&gt;More Local Wx:&lt;/a&gt;&lt;/b&gt; &lt;/td&gt;<br />
&lt;td nowrap align='right'&gt;&lt;b&gt;&lt;a href='http://www.wrh.noaa.gov/mesowest/getobext.php?wfo=psr&amp;sid=KPHX&amp;num=72' class='link'&gt;3 Day History:&lt;/a&gt;&lt;/b&gt; &lt;/td&gt;&lt;/tr&gt;<br />
&lt;/table&gt;<br />
...</code>
</div>
<p class="indent"><a id="page_171" />There are two approaches to narrowing your attention to the specific area of the document in which you are interested. You can either search the HTML for a word or phrase close to the data that you want, or, as we mentioned previously, use Google Chrome or Firefox with Firebug to &#8220;Inspect Element&#8221; and see the element you want embedded in an attractive diagram of the document tree. <a href="#fig_10_2">Figure 10&#8211;2</a> shows Google Chrome with its Developer Tools pane open following an Inspect Element command: my mouse is poised over the <code>&lt;font&gt;</code> element that was brought up in its document tree, and the element itself is highlighted in blue on the web page itself.</p>
<div id="fig_10_2" class="figure-contents">
<div class="mediaobject">
<a href="../images/inspect_element.png"><img src="../images/1002.jpg" alt="Image" /></a>
</div>
</div>
<p class="normal"><i><b>Figure 10&#8211;2.</b> Examining Document Elements in the Browser<br>(click to enlarge)</i></p>
<p class="indent">Note that Google Chrome does have an annoying habit of filling in &#8220;conceptual&#8221; tags that are not actually present in the source code, like the <code>&lt;tbody&gt;</code> tags that you can see in every one of the tables shown here. For that reason, I look at the actual HTML source before writing my Python code; I mainly use Chrome to help me find the right places in the HTML.</p>
<p class="indent">We will want to grab the text &#8220;A Few Clouds&#8221; as well as the temperature before turning our attention to the table that sits to this element&#39;s right, which contains the humidity.</p>
<p class="indent">A properly indented version of the HTML page that you are scraping is good to have at your elbow while writing code. I have included <code><a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10/phoenix-tidied.html">phoenix-tidied.html</a></code> with the source code bundle for this chapter so that you can take a look at how much easier it is to read!</p>
<p class="indent">You can see that the element displaying the current conditions in Phoenix sits very deep within the document hierarchy. Deep nesting is a very common feature of complicated page designs, and that is why simply walking a document object model can be a very verbose way to select part of a document&#8212;and, of course, a brittle one, because it will be sensitive to changes in any of the target element&#39;s parent. This will break your screen-scraping program not only if the target web site does a redesign, but also simply because changes in the time of day or the need for the site to host different kinds of ads can change the layout subtly and ruin your selector logic.</p>
<p class="indent">To see how direct document-object manipulation would work in this case, we can load the raw page directly into both the <code>lxml</code> and <code>BeautifulSoup</code> systems.</p>
<div class="pl">
<code><a id="page_172" />&gt;&gt;&gt; import lxml.etree<br />
&gt;&gt;&gt; parser = lxml.etree.HTMLParser(encoding='utf-8')<br />
&gt;&gt;&gt; tree = lxml.etree.parse('phoenix.html', parser)</code>
</div>
<p class="indent">The need for a separate <code>parser</code> object here is because, as you might guess from its name, <code>lxml</code> is natively targeted at XML files.</p>
<div class="pl">
<code>&gt;&gt;&gt; from BeautifulSoup import BeautifulSoup<br />
&gt;&gt;&gt; soup = BeautifulSoup(open('phoenix.html'))<br />
Traceback (most recent call last):<br />
&#160;&#160;...<br />
HTMLParseError: malformed start tag, at line 96, column 720</code>
</div>
<p class="indent">What on earth? Well, look, the National Weather Service does not check or tidy its HTML! I might have chosen a different example for this book if I had known, but since this is a good illustration of the way the real world works, let&#39;s press on. Jumping to line 96, column 720 of <code><a href="https://bitbucket.org/brandon/foundations-of-python-network-programming/src/f4b1736ba300/python2/10/phoenix.html#cl-96">phoenix.html</a></code>, we see that there does indeed appear to be some broken HTML:</p>
<div class="pl">
<code>&lt;a href="http://www.weather.gov"&lt;u&gt;www.weather.gov&lt;/u&gt;&lt;/a&gt;</code>
</div>
<p class="indent">You can see that the <code>&lt;u&gt;</code> tag starts before a closing angle bracket has been encountered for the <code>&lt;a&gt;</code> tag. But why should BeautifulSoup care? I wonder what version I have installed.</p>
<div class="pl">
<code>&gt;&gt;&gt; BeautifulSoup.__version__<br />
'3.1.0'</code>
</div>
<p class="indent">Well, drat. I typed too quickly and was not careful to specify a working version when I ran <code>pip</code> to install BeautifulSoup into my virtual environment. Let&#39;s try again:</p>
<div class="pl">
<code>$ pip install BeautifulSoup==3.0.8.1</code>
</div>
<p class="indent">And now the broken document parses successfully:</p>
<div class="pl">
<code>&gt;&gt;&gt; from BeautifulSoup import BeautifulSoup<br />
&gt;&gt;&gt; soup = BeautifulSoup(open('phoenix.html'))</code>
</div>
<p class="indent">That is much better!</p>
<p class="indent">Now, if we were to take the approach of starting at the top of the document and digging ever deeper until we find the node that we are interested in, we are going to have to generate some very verbose code. Here is the approach we would have to take with <code>lxml</code>:</p>
<div class="pl">
<code>&gt;&gt;&gt; fonttag = tree.find('body').find('div').findall('table')[3] \<br />
...&#160;&#160;&#160;&#160;&#160;.findall('tr')[1].find('td').findall('table')[1].find('tr') \<br />
...&#160;&#160;&#160;&#160;&#160;.findall('td')[1].findall('table')[1].find('tr').find('td') \<br />
...&#160;&#160;&#160;&#160;&#160;.find('table').findall('tr')[1].find('td').find('table') \<br />
...&#160;&#160;&#160;&#160;&#160;.find('tr').find('td').find('font')<br />
&gt;&gt;&gt; fonttag.text<br />
'\nA Few Clouds'</code>
</div>
<p class="indent">An attractive syntactic convention lets BeautifulSoup handle some of these steps more beautifully:</p>
<div class="pl">
<code>&gt;&gt;&gt; fonttag = soup.body.div('table', recursive=False)[3] \<br />
...&#160;&#160;&#160;&#160;&#160;('tr', recursive=False)[1].td('table', recursive=False)[1].tr \<br />
...&#160;&#160;&#160;&#160;&#160;('td', recursive=False)[1]('table', recursive=False)[1].tr.td \<br />
...&#160;&#160;&#160;&#160;&#160;.table('tr', recursive=False)[1].td.table \<br />
...&#160;&#160;&#160;&#160;&#160;.tr.td.font<br />
&gt;&gt;&gt; fonttag.text<br />
u'A Few Clouds71&amp;deg;F(22&amp;deg;C)'</code>
</div>
<p class="indent"><a id="page_173" />BeautifulSoup lets you choose the first child element with a given tag by simply selecting the attribute <code>.tagname</code>, and lets you receive a list of child elements with a given tag name by calling an element like a function&#8212;you can also explicitly call the method <code>findAll()</code>&#8212;with the tag name and a <code>recursive</code> option telling it to pay attention just to the children of an element; by default, this option is set to <code>True</code>, and BeautifulSoup will run off and find all elements with that tag in the entire sub-tree beneath an element!</p>
<p class="indent">Anyway, two lessons should be evident from the foregoing exploration.</p>
<p class="indent">First, both <code>lxml</code> and BeautifulSoup provide attractive ways to quickly grab a child element based on its tag name and position in the document.</p>
<p class="indent">Second, we clearly should not be using such primitive navigation to try descending into a real-world web page! I have no idea how code like the expressions just shown can easily be debugged or maintained; they would probably have to be re-built from the ground up if anything went wrong with them&#8212;they are a painful example of write-once code.</p>
<p class="indent">And that is why selectors that each screen-scraping library supports are so critically important: they are how you can ignore the many layers of elements that might surround a particular target, and dive right in to the piece of information you need.</p>
<p class="indent">Figuring out how HTML elements are grouped, by the way, is much easier if you either view HTML with an editor that prints it as a tree, or if you run it through a tool like HTML tidy from W3C that can indent each tag to show you which ones are inside which other ones:</p>
<div class="pl">
<code>$ tidy phoenix.html &gt; phoenix-tidied.html</code>
</div>
<p class="indent">You can also use either of these libraries to try tidying the code, with a call like one of these:</p>
<div class="pl">
<code>lxml.html.tostring(html)<br />
soup.prettify()</code>
</div>
<p class="indent">See each library&#39;s documentation for more details on using these calls.</p>
<h3 class="h3"><a id="selectors" />Selectors</h3>
<p class="normal">A selector is a pattern that is crafted to match document elements on which your program wants to operate. There are several popular flavors of selector, and we will look at each of them as possible techniques for finding the current-conditions <code>&lt;font&gt;</code> tag in the National Weather Service page for Phoenix. We will look at three:</p>
<ul style="list-style-type:disc">
<li>People who are deeply XML-centric prefer XPath expressions, which are a companion technology to XML itself and let you match elements based on their ancestors, their own identity, and textual matches against their attributes and text content. They are very powerful as well as quite general.</li>
<li>If you are a web developer, then you probably link to CSS selectors as the most natural choice for examining HTML. These are the same patterns used in Cascading Style Sheets documents to describe the set of elements to which each set of styles should be applied.</li>
<li>Both <code>lxml</code> and BeautifulSoup, as we have seen, provide a smattering of their own methods for finding document elements.</li>
</ul>
<p class="indent">Here are standards and descriptions for each of the selector styles just described&#8212; first, XPath:</p>
<div class="pl">
<code>http://www.w3.org/TR/xpath/<br />
http://codespeak.net/lxml/tutorial.html#using-xpath-to-find-text<br />
http://codespeak.net/lxml/xpathxslt.html</code>
</div>
<p class="indent"><a id="page_174" />And here are some CSS selector resources:</p>
<div class="pl">
<code>http://www.w3.org/TR/CSS2/selector.html<br />
http://codespeak.net/lxml/cssselect.html</code>
</div>
<p class="indent">And, finally, here are links to documentation that looks at selector methods peculiar to <code>lxml</code> and BeautifulSoup:</p>
<div class="pl">
<code>http://codespeak.net/lxml/tutorial.html#elementpath<br />
http://www.crummy.com/software/BeautifulSoup/documentation.html#Searching the Parse Tree</code>
</div>
<p class="indent">The National Weather Service has not been kind to us in constructing this web page. The area that contains the current conditions seems to be constructed entirely of generic untagged elements; none of them have <code>id</code> or <code>class</code> values like <code>currentConditions</code> or <code>temperature</code> that might help guide us to them.</p>
<p class="indent">Well, what are the features of the elements that contain the current weather conditions in <a href="#list_10_3">Listing 10&#8211;3</a>? The first thing I notice is that the enclosing <code>&lt;td&gt;</code> element has the class <code>"big"</code>. Looking at the page visually, I see that nothing else seems to be of exactly that font size; could it be so simple as to search the document for every <code>&lt;td&gt;</code> with this CSS class? Let us try, using a CSS selector to begin with:</p>
<div class="pl">
<code>&gt;&gt;&gt; from lxml.cssselect import CSSSelector<br />
&gt;&gt;&gt; sel = CSSSelector('td.big')<br />
&gt;&gt;&gt; sel(tree)<br />
[&lt;Element td at b72ec0a4&gt;]</code>
</div>
<p class="indent">Perfect! It is also easy to grab elements with a particular <code>class</code> attribute using the peculiar syntax of BeautifulSoup:</p>
<div class="pl">
<code>&gt;&gt;&gt; soup.find('td', 'big')<br />
&lt;td class="big" width="120" align="center"&gt;<br />
&lt;font size="3" color="000066"&gt;<br />
A Few Clouds&lt;br /&gt;<br />
&lt;br /&gt;71&amp;deg;F&lt;br /&gt;(22&amp;deg;C)&lt;/font&gt;&lt;/td&gt;</code>
</div>
<p class="indent">Writing an XPath selector that can find CSS classes is a bit difficult since the <code>class=""</code> attribute contains space-separated values and we do not know, in general, whether the class will be listed first, last, or in the middle.</p>
<div class="pl">
<code>&gt;&gt;&gt; tree.xpath(".//td[contains(concat(' ', normalize-space(@class), ' '), ' big ')]")<br />
[&lt;Element td at a567fcc&gt;]</code>
</div>
<p class="indent">This is a common trick when using XPath against HTML: by prepending and appending spaces to the <code>class</code> attribute, the selector assures that it can look for the target class name with spaces around it and find a match regardless of where in the list of classes the name falls.</p>
<p class="indent">Selectors, then, can make it simple, elegant, and also quite fast to find elements deep within a document that interest us. And if they break because the document is redesigned or because of a corner case we did not anticipate, they tend to break in obvious ways, unlike the tedious and deep procedure of walking the document tree that we attempted first.</p>
<p class="indent">Once you have zeroed in on the part of the document that interests you, it is generally a very simple matter to use the ElementTree or the old BeautifulSoup API to get the text or attribute values you need. Compare the following code to the actual tree shown in <a href="#list_10_3">Listing 10&#8211;3</a>:</p>
<div class="pl">
<code>&gt;&gt;&gt; td = sel(tree)[0]<br />
&gt;&gt;&gt; td.find('font').text<br />
'\nA Few Clouds'<br />
&gt;&gt;&gt; td.find('font').findall('br')[1].tail<br />
u'71&#176;F'</code>
</div>
<p class="indent"><a id="page_175" />If you are annoyed that the first string did not return as a Unicode object, you will have to blame the ElementTree standard; the glitch has been corrected in Python 3! Note that ElementTree thinks of text strings in an HTML file not as entities of their own, but as either the <code>.text</code> of its parent element or the <code>.tail</code> of the previous element. This can take a bit of getting used to, and works like this:</p>
<div class="pl">
<code>&lt;p&gt;<br />
&#160;&#160;My favorite play is&#160;&#160;&#160;&#160;# the &lt;p&gt; element's .text<br />
&#160;&#160;&lt;i&gt;<br />
 &#160;&#160;&#160;Hamlet&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# the &lt;i&gt; element's .text<br />
&#160;&#160;&lt;/i&gt;<br />
&#160;&#160;which is not really&#160;&#160;&#160;&#160;&#160;&#160;# the &lt;i&gt; element's .tail<br />
&#160;&#160;&lt;b&gt;<br />
 &#160;&#160;&#160;Danish&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# the &lt;b&gt; element's .text<br />
&#160;&#160;&lt;/b&gt;<br />
&#160;&#160;but English.&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# the &lt;b&gt; element's .tail<br />
&lt;/p&gt;</code>
</div>
<p class="indent">This can be confusing because you would think of the three words <code>favorite</code> and <code>really</code> and <code>English</code> as being at the same &#8220;level&#8221; of the document&#8212;as all being children of the <code>&lt;p&gt;</code> element somehow&#8212;but <code>lxml</code> considers only the first word to be part of the text attached to the <code>&lt;p&gt;</code> element, and considers the other two to belong to the tail texts of the inner <code>&lt;i&gt;</code> and <code>&lt;b&gt;</code> elements. This arrangement can require a bit of contortion if you ever want to move elements without disturbing the text around them, but leads to rather clean code otherwise, if the programmer can keep a clear picture of it in her mind.</p>
<p class="indent">BeautifulSoup, by contrast, considers the snippets of text and the <code>&lt;br&gt;</code> elements inside the <code>&lt;font&gt;</code> tag to all be children sitting at the same level of its hierarchy. Strings of text, in other words, are treated as phantom elements. This means that we can simply grab our text snippets by choosing the right child nodes:</p>
<div class="pl">
<code>&gt;&gt;&gt; td = soup.find('td', 'big')<br />
&gt;&gt;&gt; td.font.contents[0]<br />
u'\nA Few Clouds'<br />
&gt;&gt;&gt; td.font.contents[4]<br />
u'71&amp;deg;F'</code>
</div>
<p class="indent">Through a similar operation, we can direct either <code>lxml</code> or BeautifulSoup to the humidity datum. Since the word <code>Humidity:</code> will always occur literally in the document next to the numeric value, this search can be driven by a meaningful term rather than by something as random as the <code>big</code> CSS tag. See <a href="#list_10_4">Listing 10&#8211;4</a> for a complete screen-scraping routine that does the same operation first with <code>lxml</code> and then with BeautifulSoup.</p>
<p class="indent">This complete program, which hits the National Weather Service web page for each request, takes the city name on the command line:</p>
<div class="pl">
<code>$ python weather.py Springfield, IL<br />
Condition:<br />
Traceback (most recent call last):<br />
&#160;&#160;...<br />
AttributeError: 'NoneType' object has no attribute 'text'</code>
</div>
<p class="indent">And here you can see, superbly illustrated, why screen scraping is always an approach of last resort and should always be avoided if you can possibly get your hands on the data some other way: because presentation markup is typically designed for one thing&#8212;human readability in browsers&#8212;and can vary in crazy ways depending on what it is displaying.</p>
<p class="indent">What is the problem here? A short investigation suggests that the NWS page includes only a <code>&lt;font&gt;</code> element inside of the <code>&lt;tr&gt;</code> if&#8212;and this is just a guess of mine, based on a few examples&#8212;the description of the current conditions is several words long and thus happens to contain a space. The conditions in Phoenix as I have written this chapter are &#8220;A Few Clouds,&#8221; so the foregoing code has worked just fine; <a id="page_176" />but in Springfield, the weather is &#8220;Fair&#8221; and therefore does not need a <code>&lt;font&gt;</code> wrapper around it, apparently.</p>
<div id="list_10_4" class="listing">
<p class="normal"><i><b>Listing 10&#8211;4.</b> Completed Weather Scraper</i></p>
<code>#!/usr/bin/env python<br />
# Foundations of Python Network Programming - Chapter 10 - weather.py<br />
# Fetch the weather forecast from the National Weather Service.<br />
<br />
import sys, urllib, urllib2<br />
import lxml.etree<br />
from lxml.cssselect import CSSSelector<br />
from BeautifulSoup import BeautifulSoup<br />
<br />
if len(sys.argv) &lt; 2:<br />
 &#160;&#160;&#160;print &gt;&gt;sys.stderr, 'usage: weather.py CITY, STATE'<br />
 &#160;&#160;&#160;exit(2)<br />
<br />
data = urllib.urlencode({'inputstring': ' '.join(sys.argv[1:])})<br />
info = urllib2.urlopen('http://forecast.weather.gov/zipcity.php', data)<br />
content = info.read()<br />
<br />
# Solution #1<br />
parser = lxml.etree.HTMLParser(encoding='utf-8')<br />
tree = lxml.etree.fromstring(content, parser)<br />
big = CSSSelector('td.big')(tree)[0]<br />
if big.find('font') is not None:<br />
 &#160;&#160;&#160;big = big.find('font')<br />
print 'Condition:', big.text.strip()<br />
print 'Temperature:', big.findall('br')[1].tail<br />
tr = tree.xpath('.//td[b="Humidity"]')[0].getparent()<br />
print 'Humidity:', tr.findall('td')[1].text<br />
print<br />
<br />
# Solution #2<br />
soup = BeautifulSoup(content)&#160;&#160;# doctest: +SKIP<br />
big = soup.find('td', 'big')<br />
if big.font is not None:<br />
 &#160;&#160;&#160;big = big.font<br />
print 'Condition:', big.contents[0].string.strip()<br />
temp = big.contents[3].string or big.contents[4].string&#160;&#160;# can be either<br />
print 'Temperature:', temp.replace('&amp;deg;', ' ')<br />
tr = soup.find('b', text='Humidity').parent.parent.parent<br />
print 'Humidity:', tr('td')[1].string<br />
print</code>
</div>
<p class="indent">If you look at the final form of <a href="#list_10_4">Listing 10&#8211;4</a>, you will see a few other tweaks that I made as I noticed changes in format with different cities. It now seems to work against a reasonable selection of locations; again, note that it gives the same report twice, generated once with <code>lxml</code> and once with BeautifulSoup:</p>
<div class="pl">
<code>$ python weather.py Springfield, IL<br />
Condition: Fair<br />
Temperature: 54 &#176;F<br />
Humidity: 28 %</code><br />
<br />
<code><a id="page_177" />Condition: Fair<br />
Temperature: 54&#160;&#160;F<br />
Humidity: 28 %<br />
<br />
$ python weather.py Grand Canyon, AZ<br />
Condition: Fair<br />
Temperature: 67&#176;F<br />
Humidity: 28 %<br />
<br />
Condition: Fair<br />
Temperature: 67 F<br />
Humidity: 28 %</code>
</div>
<p class="indent">You will note that some cities have spaces between the temperature and the <code>F</code>, and others do not. No, I have no idea why. But if you were to parse these values to compare them, you would have to learn every possible variant and your parser would have to take them into account.</p>
<p class="indent">I leave it as an exercise to the reader to determine why the web page currently displays the word &#8220;NULL&#8221;&#8212;you can even see it in the browser&#8212;for the temperature in Elk City, Oklahoma. Maybe that location is too forlorn to even deserve a reading? In any case, it is yet another special case that you would have to treat sanely if you were actually trying to repackage this HTML page for access from an API:</p>
<div class="pl">
<code>$ python weather.py Elk City, OK<br />
Condition: Fair and Breezy<br />
Temperature: NULL<br />
Humidity: NA<br />
<br />
Condition: Fair and Breezy<br />
Temperature: NULL<br />
Humidity: NA</code>
</div>
<p class="indent">I also leave as an exercise to the reader the task of parsing the error page that comes up if a city cannot be found, or if the Weather Service finds it ambiguous and prints a list of more specific choices!</p>
<h3 class="h3"><a id="summary8" />Summary</h3>
<p class="normal">Although the Python Standard Library has several modules related to SGML and, more specifically, to HTML parsing, there are two premier screen-scraping technologies in use today: the fast and powerful <code>lxml</code> library that supports the standard Python &#8220;ElementTree&#8221; API for accessing trees of elements, and the quirky BeautifulSoup library that has powerful API conventions all its own for querying and traversing a document.</p>
<p class="indent">If you use BeautifulSoup before 3.2 comes out, be sure to download the most recent 3.0 version; the 3.1 series, which unfortunately will install by default, is broken and chokes easily on HTML glitches.</p>
<p class="indent">Screen scraping is, at bottom, a complete mess. Web pages vary in unpredictable ways even if you are browsing just one kind of object on the site&#8212;like cities at the National Weather Service, for example.</p>
<p class="indent">To prepare to screen scrape, download a copy of the page, and use HTML tidy, or else your screen-scraping library of choice, to create a copy of the file that your eyes can more easily read. Always run your program against the ugly original copy, however, lest HTML tidy fixes something in the markup that your program will need to repair!</p>
<p class="indent">Once you find the data you want in the web page, look around at the nearby elements for tags, classes, and text that are unique to that spot on the screen. Then, construct a Python command using your scraping library that looks for the pattern you have discovered and retrieves the element in question. By looking at its children, parents, or enclosed text, you should be able to pull out the data that you need from the web page intact.</p>
<p class="indent"><a id="page_178" />When you have a basic script working, continue testing it; you will probably find many edge cases that have to be handled correctly before it becomes generally useful. Remember: when possible, always use true APIs, and treat screen scraping as a technique of last resort!</p>
<img src="http://www.assoc-amazon.com/e/ir?t=letsdisthemat-20&l=as2&o=1&a=1430230037" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<blockquote><i>©2010 by Brandon Rhodes and John Goerzen</i></blockquote>
</article></%self:filter>
