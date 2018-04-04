<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:svg="http://www.w3.org/2000/svg"
		xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" encoding="utf-8" />
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="svg:svg">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="svg:svg/@width" />
  <xsl:template match="svg:svg/@height" />

  <xsl:template match="svg:*[@id='background']" />
  
  <xsl:template match="* | @* | comment() | text() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
