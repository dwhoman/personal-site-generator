<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		exclude-result-prefixes="xlink svg">
  <xsl:output method="xml" encoding="utf-8" />
  <xsl:template match="/">
    <html>
      <head>
	<title>Blog Threads</title>
	<meta name="author" content="Devin Homan" />
	<meta name="description" content="Blog threads." />
	<link rel="stylesheet" type="text/css" href="./css/threads.css" />
      </head>
      <body>
	<main>
	  <h1>Blog Post Threads</h1>
	  <xsl:apply-templates />
	  <div id="link-auxiliary">
	    <label title="If your browser does not support svg links." for="show-links">List Links</label>
	    <input type="checkbox" id="show-links" />
	    <ol id="thread-links">
	      <xsl:apply-templates select="//svg:a" mode="foreignObject" />
	    </ol>
	  </div>
	</main>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="svg:a/@href">
    <xsl:attribute name="href">
      <xsl:text>blog/</xsl:text><xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="svg:svg">
    <div id="graph-container">
      <svg width="{@width}" height="{@height}">
	<style>
	  a:hover { cursor: pointer; }
	</style>
	<xsl:apply-templates />
      </svg>
    </div>
  </xsl:template>

  <xsl:template match="svg:a" mode="foreignObject">
    <li>
      <a>
	<xsl:apply-templates select="@xlink:href" />
	<xsl:value-of select="svg:text/text()" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="svg:text/text()">
    <xsl:value-of select="translate(., '_', ' ')" />
  </xsl:template>

  <xsl:template match="svg:title/text()">
    <!-- This is the text that displays on mouse-over. Change to blog post description. -->
    <xsl:value-of select="translate(., '_', ' ')" />
  </xsl:template>

  <!-- template to copy elements -->
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <!-- template to copy attributes -->
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- template to copy the rest of the nodes -->
  <xsl:template match="comment() | text() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>
</xsl:stylesheet>
