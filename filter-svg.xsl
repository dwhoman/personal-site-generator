<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:cc="http://creativecommons.org/ns#"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
		xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
		exclude-result-prefixes="dc cc rdf sodipodi inkscape">
  <xsl:output method="xml" encoding="utf-8" />
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <!-- remove width and height attributes -->
  <!-- <xsl:template match="svg:svg/@width" /> -->
  <!-- <xsl:template match="svg:svg/@height" /> -->
  
  <!-- remove extraneous Inkscape stuff -->
  <xsl:template match="inkscape:*" />
  <xsl:template match="@inkscape:*" />
  <xsl:template match="dc:*" />
  <xsl:template match="@dc:*" />
  <xsl:template match="cc:*" />
  <xsl:template match="@cc:*" />
  <xsl:template match="rdf:*" />
  <xsl:template match="@rdf:*" />
  <xsl:template match="sodipodi:*" />
  <xsl:template match="@sodipodi:*" />
  
  <xsl:template match="svg:rect[@id='background']" />
  
  <xsl:template match="* | @* | comment() | text() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
