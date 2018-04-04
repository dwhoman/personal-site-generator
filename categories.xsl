<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" />
  <xsl:param name="css_version" />
  <xsl:key name="article-by-topic" match="//entry" use="keywords/keyword/@uri" />
  <xsl:template match="/">
    <html>
      <head>
	<title>Tag Index</title>
	<meta name="author" content="Devin Homan" />
	<meta name="description" content="Blog indexed by tag." />
	<link rel='stylesheet' type='text/css' href='./css/tables.css' />
	<!-- ?ver={$css_version} -->
	<link rel='stylesheet' type='text/css' href='./css/categories.css' />
      </head>
      <body>
	<main>
	  <h1>Tag Index</h1>
	  <article>
	    <h2>Keywords</h2>
	    <ul id="keywords">
	      <xsl:for-each select="//keys/word">
		<xsl:sort select="@id" />
		<li class="cloud"><a style="font-size: {@data-scale * 2 + 10}pt;" href="categories.xhtml#{@id}"><xsl:value-of select="text()" /></a></li>
	      </xsl:for-each>
	    </ul>
	    <xsl:for-each select="//keys/word">
	      <xsl:sort select="@id" />
	      <h2 class="category" id="{@id}"><xsl:value-of select="text()" /></h2>
	      <div class="category">
		<table class='index'>
		  <thead>
		    <tr>
		      <th>Article</th>
		      <th>Published</th>
		      <th>Updated</th>
		    </tr>
		  </thead>
		  <xsl:for-each select="key('article-by-topic', @id)">
		    <xsl:sort select="title/text()" />
		    <xsl:apply-templates select=".">
		      <xsl:with-param name="tbody">name-sort</xsl:with-param>
		    </xsl:apply-templates>
		  </xsl:for-each>
		</table>
	      </div>
	    </xsl:for-each>
	  </article>
	</main>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="entry">
    <xsl:param name="tbody" />
    <tbody class="{$tbody}">
      <tr>
	<td>
	  <a href="blog/{file/text()}"><xsl:value-of select="title/text()" /></a>
	</td>
	<td>
	  <time data-unix="{published/@date}" datetime="{published/@datetime}"><xsl:value-of select="published/text()"/></time>
	</td>
	<td>
	  <time data-unix="{updated/@date}" datetime="{updated/@datetime}"><xsl:value-of select="updated/text()"/></time>
	</td>
      </tr>
      <tr>
	<td colspan="3">
	  <xsl:value-of select="description/text()" />
	</td>
      </tr>
      <tr>
	<td colspan="3">
	  <xsl:for-each select="keywords/keyword">
	    <xsl:sort select="." />
	    <a href="categories.xhtml#{@uri}" ><xsl:value-of select="text()" /></a>
	    <span class="delimiter">, </span>
	  </xsl:for-each>
	</td>
      </tr>
    </tbody>
  </xsl:template>
</xsl:stylesheet>
