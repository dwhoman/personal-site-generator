<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="x">
  <xsl:output method="xml" />
  <xsl:param name="title" />
  <xsl:param name="order" select="0" />
  <xsl:template match="/">
    <html>
      <head>
	<title><xsl:value-of select="$title" /></title>
	<meta name="author" content="Devin Homan" />
	<meta name="description" content="Blog index." />
	<link rel='stylesheet' type='text/css' href='./css/tables.css' />
	<link rel='stylesheet' type='text/css' href='./css/date-index.css' />
      </head>
      <body>
	<main>
	  <h1><xsl:value-of select="$title" /></h1>
	  <table class='index'>
	    <thead>
	      <tr>
		<th>Article</th><th>Published</th><th>Updated</th>
	      </tr>
	    </thead>
	    <tbody>
	      <xsl:choose>
		<xsl:when test="$order = 0">
		  <xsl:for-each select="//entry">
		    <xsl:sort order="descending" select="published/@date" />
		    <xsl:apply-templates select="." />
		  </xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:for-each select="//entry">
		    <xsl:sort order="descending" select="updated/@date" />
		    <xsl:apply-templates select="." />
		  </xsl:for-each>
		</xsl:otherwise>
	      </xsl:choose>
	    </tbody>
	  </table>
	</main>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="entry">
    <tbody>
      <tr>
	<td>
	  <a href="blog/{file}"><xsl:value-of select="title" /></a>
	</td>
	<td>
	  <time datetime="{published/@datetime}"><xsl:value-of select="published"/></time>
	</td>
	<td>
	  <time datetime="{updated/@datetime}"><xsl:value-of select="updated"/></time>
	</td>
      </tr>
      <tr>
	<td colspan="3">
	  <xsl:for-each select="keywords/keyword">
	    <xsl:sort select="." />
	    <xsl:if test="position() > 1">
	      <span>, </span>
	    </xsl:if>
	    <a href="categories.html#{@uri}" ><xsl:value-of select="text()" /></a>
	  </xsl:for-each>
	</td>
      </tr>
      <tr>
	<td colspan="3">
	  <xsl:value-of select="description" />
	</td>
      </tr>
    </tbody>
  </xsl:template>
</xsl:stylesheet>
