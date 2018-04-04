<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="x">
  <xsl:output method="xml" encoding="utf-8" />
  <xsl:param name="file" />
  <xsl:param name="metadata" />
  <xsl:variable name="file-html" select="concat($file, '.html')" />
  <xsl:template match="/">
    <html lang="en">
      <head>
	<xsl:apply-templates select="//x:head/x:title" />
	<xsl:apply-templates select="//x:head/x:meta[@name = 'author']" />
	<xsl:apply-templates select="//x:head/x:meta[@name = 'description']" />
	<xsl:apply-templates select="//x:head/x:meta[@name = 'keywords']" />
	<xsl:apply-templates select="//x:head/x:meta[@name = 'generator']" />
	<link rel="stylesheet" type="text/css" href="../css/exposition.css" />
	<link rel='stylesheet' type='text/css' href='../css/blog.css' />
	<link rel='stylesheet' type='text/css' href='../css/{$file}.css' />
      </head>
      <body>
	<aside id="related-posts">
	  <xsl:if test="document($metadata)//entry[file/text() = $file-html]/*[name()='prev' or name()='next']">
	    <nav id="blog-threads-local">
	      <h2>Thread</h2>
	      <dl>
		<xsl:if test="document($metadata)//entry[file/text() = $file-html]/prev">
		  <dt>Prev:</dt>
		  <xsl:for-each select="document($metadata)//entry[file/text() = $file-html]/prev">
		    <xsl:variable name="link-name" select="text()" />
		    <dd class="cloud">
		      <a href="{$link-name}">
			<xsl:value-of select="document($metadata)//entry[file/text() = $link-name]/title" />
		      </a>
		    </dd>
		  </xsl:for-each>
		</xsl:if>
		<xsl:if test="document($metadata)//entry[file/text() = $file-html]/next">
		  <dt>Next:</dt>
		  <xsl:for-each select="document($metadata)//entry[file/text() = $file-html]/next">
		    <xsl:variable name="link-name" select="text()" />
		    <dd class="cloud">
		      <a href="{$link-name}">
			<xsl:value-of select="document($metadata)//entry[file/text() = $link-name]/title" />
		      </a>
		    </dd>
		  </xsl:for-each>
		</xsl:if>
	      </dl>
	    </nav>
	  </xsl:if>
	  <nav id="blog-published-local">
	    <h2>Published</h2>
	    <dl>
	      <xsl:for-each select="document($metadata)//entry[published/@date &lt; /index/entry[file/text() = $file-html]/published/@date]">
		<xsl:sort order="descending" />
		  <xsl:if test="position() = 1">
		    <dt>Prev:</dt>
		    <dd class="cloud">
		      <a href="{file/text()}"><xsl:value-of select="title/text()" /></a>
		    </dd>
		  </xsl:if>
	      </xsl:for-each>
	      <xsl:for-each select="document($metadata)//entry[published/@date &gt; /index/entry[file/text() = $file-html]/published/@date]">
		<xsl:sort order="ascending" />
		<xsl:if test="position() = 1">
		  <dt>Next:</dt>
		  <dd class="cloud">
		    <a href="{file/text()}"><xsl:value-of select="title/text()" /></a>
		  </dd>
		</xsl:if>
	      </xsl:for-each>
	    </dl>
	  </nav>
	  <nav id="blog-updated-local">
	    <h2>Updated</h2>
	    <dl>
	      <xsl:for-each select="document($metadata)//entry[updated/@date &lt; /index/entry[file/text() = $file-html]/updated/@date]">
		<xsl:sort order="descending" />
		<xsl:if test="position() = 1">
		  <dt>Prev:</dt>
		  <dd class="cloud">
		    <a href="{file/text()}"><xsl:value-of select="title/text()" /></a>
		  </dd>
		</xsl:if>
	      </xsl:for-each>
	      <xsl:for-each select="document($metadata)//entry[updated/@date &gt; /index/entry[file/text() = $file-html]/updated/@date]">
		<xsl:sort order="ascending" />
		<xsl:if test="position() = 1">
		  <dt>Next:</dt>
		  <dd class="cloud">
		    <a href="{file/text()}"><xsl:value-of select="title/text()" /></a>
		  </dd>
		</xsl:if>
	      </xsl:for-each>
	    </dl>
	  </nav>
	  <nav id='tag-list'>
	    <h2>Tags</h2>
	    <ul>
	      <xsl:for-each select="document($metadata)//entry[file = $file-html]/keywords/keyword">
		<xsl:sort order="ascending" />
		<li><a href="../categories.xhtml#{translate(.,' ','_')}"><xsl:value-of select="." /></a></li>
	      </xsl:for-each>
	    </ul>
	  </nav>
	</aside>
	<aside id='generation-dates'>
	  <ul>
	    <li id='publication-date'>Published: <time datetime="{document($metadata)//entry[file = $file-html]/published/@datetime}">
	    <xsl:value-of select="document($metadata)//entry[file = $file-html]/published" /></time></li>
	    <xsl:if test="document($metadata)//entry[file = $file-html]/published != document($metadata)//entry[file = $file-html]/updated">
	      <li id='update-date'>Updated: <time datetime="{document($metadata)//entry[file = $file-html]/updated/@datetime}">
	      <xsl:value-of select="document($metadata)//entry[file = $file-html]/updated" /></time></li>
	    </xsl:if>
	    <li id='markup-source'><a href="{concat($file, '.org')}" type='text/plain' download="{concat($file, '.org')}">Page Markup Source</a></li>
	  </ul>
	</aside>
	<xsl:apply-templates select="//x:body/x:main" />
      </body>
    </html>
  </xsl:template>

  <!-- use footntes to add alt text to equations -->
  <xsl:template match="x:object[starts-with(@data,'ltximg')]">
    <xsl:variable name="objid" select="following-sibling::x:sup[1]/x:a/@href" />
    <img class='latex org-svg' src='{@data}'>
      <xsl:attribute name="alt">
	<xsl:choose>
	  <xsl:when test="$objid">
	    <xsl:value-of select="//x:div[@class='footdef']/x:sup[child::x:a[@id = substring-after($objid,'#')]]/following-sibling::x:div[@class = 'footpara'][1]" />
	  </xsl:when>
	  <xsl:otherwise><xsl:text>LateX equation.</xsl:text></xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
    </img>
  </xsl:template>
  <xsl:template match="x:sup[preceding-sibling::x:object[1][starts-with(@data,'ltximg')]]" />
  <xsl:template match="x:div[@id = 'footnotes']" />

  <xsl:template match="x:object[@class='org-svg']">
    <img class='org-svg' src='{@data}'>
      <xsl:attribute  name="alt">
	<xsl:choose>
	  <xsl:when test="@alt">
	    <xsl:value-of select="@alt" />
	  </xsl:when>
	  <xsl:otherwise>SVG Image.</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- strip namespaces off of nodes -->
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <!-- strip namespaces off of attributes -->
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="comment() | text() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
