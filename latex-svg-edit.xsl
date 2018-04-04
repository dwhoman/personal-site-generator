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

  <!-- <xsl:template match="svg:svg/@width" /> -->
  <!-- <xsl:template match="svg:svg/@height" /> -->

  <xsl:template match="svg:*[contains(@fill,'#ff0000')]/@fill">
    <xsl:attribute name="fill">#a52a2a</xsl:attribute>    
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:copy>
      <xsl:if test="@fill='#ffffff' and not(@fill-opacity)">
	<xsl:attribute name="fill-opacity">0</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | comment() | text() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
