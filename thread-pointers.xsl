<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:gxl="http://www.gupro.de/GXL"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		exclude-result-prefixes="gxl xlink">
  <xsl:output method="xml" encoding="utf-8" />
  <xsl:key name="edge-by-to" match="edge" use="@to" />
  <xsl:key name="edge-by-from" match="edge" use="@from" />
  <xsl:key name="node-by-id" match="node" use="@id" />
  <xsl:template match="/">
    <xml>
      <xsl:apply-templates select="//node" />
    </xml>
  </xsl:template>
  <xsl:template match="node">
    <post>
      <file><xsl:value-of select="attr[@name='href']/string/text()" /></file>
      <xsl:if test="key('edge-by-to', @id)">
	<prev>
	  <xsl:apply-templates select="key('edge-by-to', @id)" mode="from" />
	</prev>
      </xsl:if>
      <xsl:if test="key('edge-by-from', @id)">
	<next>
	  <xsl:apply-templates select="key('edge-by-from', @id)" mode="to" />
	</next>
      </xsl:if>
    </post>
  </xsl:template>

  <xsl:template match="edge" mode="to">
    <xsl:value-of select="key('node-by-id', @to)/attr[@name='href']/string" />
  </xsl:template>

  <xsl:template match="edge" mode="from">
    <xsl:value-of select="key('node-by-id', @from)/attr[@name='href']/string" />
  </xsl:template>
</xsl:stylesheet>
