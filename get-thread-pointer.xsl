<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="file" />
  <xsl:output method="xml" />
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//file[text() = $file]">
	<xsl:copy-of select="//post[file[text() = $file]]" />
      </xsl:when>
      <xsl:otherwise>
	<error><xsl:value-of select="$file" /></error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
