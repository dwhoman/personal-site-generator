<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" />
  <xsl:template match="/">
    <feed xmlns="http://www.w3.org/2005/Atom">
      <title type="text">DWHoman Atom Feed</title>
      <link rel="self" type="application/atom+xml"
	    href="http://www.dwhoman.com/feed.atom" />
      <link href="http://www.dwhoman.com/" />
      <rights>Copyright (c) 2018, Devin Homan</rights>
      <author><name>Devin Homan</name></author>
      <updated>
	<xsl:for-each select="//entry">
	  <xsl:sort select="updated/@date" order="descending" data-type="text" />
	  <xsl:if test="position() = 1">
	    <xsl:value-of select="updated/@datetime" />
	  </xsl:if>
	</xsl:for-each>
      </updated>
      <id>tag:http://www.dwhoman.com</id>
      <xsl:for-each select="//entry">
	<entry>
	  <title><xsl:value-of select="title" /></title>
	  <id>tag:http://www.dwhoman.com/<xsl:value-of select="file" /></id>
	  <link href="http://www.dwhoman.com/{file}" />
	  <updated><xsl:value-of select="updated/@datetime"/></updated>
	  <published><xsl:value-of select="published/@datetime"/></published>
	  <summary><xsl:value-of select="description" /></summary>
	  <xsl:for-each select="keywords/keyword">
	    <xsl:sort select="." />
	    <category term="{text()}" />
	  </xsl:for-each>
	</entry>
      </xsl:for-each>
    </feed>
  </xsl:template>
</xsl:stylesheet>
