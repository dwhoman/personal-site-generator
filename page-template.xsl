<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="x">
  <xsl:param name="css_version" />
  <xsl:param name="relative">.</xsl:param>
  <xsl:output method="html" media-type="text/html" />
  <!-- <script type='text/javascript' async='async' src='{$relative}/js/main.js'/> -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html lang="en">
      <head>
	<!-- meta set by xsltproc -->
	<link rel="alternate" type="application/atom+xml" href="{$relative}/feed.atom" />
	<link rel="shortcut icon" href="{$relative}/graphics/logo3.svg" />
	<link rel="preload" href="{$relative}/fonts/genoa_italic_filtered.woff" as="font" type="font/woff" />
	<xsl:copy-of select="//head/title" />
	<xsl:for-each select="//head/meta[not(@charset)]">
	  <xsl:copy-of select="." />
	</xsl:for-each>
	<!-- ?ver={$css_version} -->
	<link rel='stylesheet' type='text/css' href='{$relative}/css/main.css' />
	<!-- page specific style sheets -->
	<xsl:for-each select="//head/link">
	  <xsl:copy-of select="." />
	</xsl:for-each>
	<xsl:for-each select="//head/script">
	  <xsl:copy-of select="." />
	</xsl:for-each>
      </head>
      <body>
	<header id="masthead">
	  <input id="expand-blog-menu" type="checkbox" tabindex="2" />
	  <div id="dwhoman-logo" class="nav"><a href="{$relative}/index.html" tabindex="1"><span>D</span><span>W</span><span>H</span></a></div>
	  <label id="expand-blog-menu-inactive" class="nav menu menu-btn" for="expand-blog-menu">
	    <span>Blog</span><img src="{$relative}/graphics/noun_1322581_cc.svg" alt="" />
	  </label>
	  <label id="expand-blog-menu-active" class="nav blog-menu menu-btn" for="expand-blog-menu">
	    <span>Main Menu</span><img src="{$relative}/graphics/noun_1355740_cc.svg" alt="" />
	  </label>
	  <div id="blog-chronologic" class="nav blog-menu menu-btn">
	    <a href="{$relative}/chronological.html" tabindex="3"><span>Chronological</span><img src="{$relative}/graphics/noun_333757_cc.svg" alt="" /></a>
	  </div>
	  <div id="blog-recent" class="nav blog-menu menu-btn">
	    <a href="{$relative}/recent-updates.html" tabindex="4"><span>Updated</span><img src="{$relative}/graphics/noun_1572678_cc.svg" alt="" /></a>
	  </div>
	  <div id="blog-categories" class="nav blog-menu menu-btn">
	    <a href="{$relative}/categories.xhtml" tabindex="5"><span>Categories</span><img src="{$relative}/graphics/noun_1332809_cc.svg" alt="" /></a>
	  </div>
	  <div id="blog-threads" class="nav blog-menu menu-btn">
	    <a href="{$relative}/threads.html" tabindex="6"><span>Threads</span><img src="{$relative}/graphics/noun_844785_cc.svg" alt="" /></a>
	  </div>
	  <div id="blog-feed" class="nav blog-menu menu-btn">
	    <a href="{$relative}/feed.atom" tabindex="7"><span>Feed</span><img src="{$relative}/graphics/noun_19895_cc.svg" alt="" /></a>
	  </div>
	  <div id="about-page" class="nav menu menu-btn">
	    <a href="{$relative}/about.html" tabindex="8"><span>About</span><img src="{$relative}/graphics/info.svg" alt="" /></a>
	  </div>
	  <div id="resume-page" class="nav menu menu-btn">
	    <a href="{$relative}/resume.html" tabindex="9"><span>R<span class="acute-e">e</span>sum<span class="acute-e">e</span></span>
	    <img src="{$relative}/graphics/noun_591006_cc.svg" alt="" /></a>
	  </div>
	  <div id="project-page" class="nav menu menu-btn"><a href="https://github.com/dwhoman" tabindex="10">
	    <span>Projects</span><img src="{$relative}/graphics/Git-logo.svg" alt="" /></a>
	  </div>
	  <div id="following-page" class="menu nav menu-btn">
	    <a href="{$relative}/blog/following.html" tabindex="11"><span>Following</span><img src="{$relative}/graphics/noun_541507_cc.svg" alt="" /></a> 
	  </div>

	  <div id="blog-feed-comp" class="filler menu"></div>
	  <div id="nav-filler" class="filler"></div>
	  <div id="to-top" class="nav menu-btn">
	    <a href="#" tabindex="12"><span>Back to Top</span><img src="{$relative}/graphics/to_top.svg" alt="" /></a>
	  </div>
	  <!-- <div id='doodles-index' class='menu menu-btn'><a href='{$relative}/svg.html'>Doodles</a></div> -->

	  <!-- <div><a href='{$relative}/svg.html'>HTML5</a></div> -->
	</header>
	<xsl:copy-of select="//aside" />
	<xsl:copy-of select="//main" />
	<footer>
	  <div id="to-top-alt" class="mobile nav menu-btn"><a href="#" tabindex="-1">Back to Top</a></div>
	</footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
