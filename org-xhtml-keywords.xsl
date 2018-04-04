<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml">
  <!-- Given a file exported by org mode, output the title, modification date, publication date, and keywords as a CSV -->
  <xsl:param name="file" />
  <xsl:output method="text" />
  <xsl:template match="/">
    <xsl:value-of select="$file" />,<xsl:copy-of select="//x:title" />,<xsl:value-of select="substring(//x:p[@id='mod-time'],1,4)" /><xsl:value-of select="substring(//x:p[@id='mod-time'],6,2)" /><xsl:value-of select="substring(//x:p[@id='mod-time'],9,2)" /><xsl:value-of select="substring(//x:p[@id='mod-time'],16,2)" /><xsl:value-of select="substring(//x:p[@id='mod-time'],19,2)" />,<xsl:value-of select="substring(//x:p[@id='date'],1,4)" /><xsl:value-of select="substring(//x:p[@id='date'],6,2)" /><xsl:value-of select="substring(//x:p[@id='date'],9,2)" /><xsl:value-of select="substring(//x:p[@id='date'],16,2)" /><xsl:value-of select="substring(//x:p[@id='date'],19,2)" />,<xsl:value-of select="//x:meta[@name='keywords']/@content" /><xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
