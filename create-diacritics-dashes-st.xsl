<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/XSL/TransformAlias"
		xmlns:exslt='http://exslt.org/common'>
  <xsl:output method="xml" />

  <xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl" />
  <xsl:template match="/">
    <x:stylesheet version="1.0">
      <xsl:attribute name='extension-element-prefixes'>exslt</xsl:attribute>
      <xsl:text>
      </xsl:text>
      <x:output method="html" />
      <xsl:text>
      </xsl:text>
      <x:template match="/">
	<xsl:text>
	</xsl:text>
	<x:apply-templates />
	<xsl:text>
	</xsl:text>
      </x:template>
      <xsl:for-each select="//word">
	<xsl:text>
	</xsl:text>
	<x:template match="text()[contains(., '{@val}')]" priority="2" mode="replace">
	  <x:apply-templates select="exslt:node-set(substring-before(., '{@val}'))" mode='replace' /><xsl:apply-templates select="*|text()" /><x:apply-templates select="exslt:node-set(substring-after(., '{@val}'))" mode='replace' />
	</x:template>
	<xsl:text>
	</xsl:text>
      </xsl:for-each>
      <xsl:text>
      </xsl:text>
      <x:template match="text()" mode="replace" priority="1">
	<xsl:text>
	</xsl:text>
	<x:value-of select="." />
	<xsl:text>
	</xsl:text>
      </x:template>
      <xsl:text>
      </xsl:text>
      <x:template match="text()">
	<xsl:text>
	</xsl:text>
	<x:value-of select="." />
	<xsl:text>
	</xsl:text>
      </x:template>
      <xsl:text>
      </xsl:text>
      <x:template match="*|@*|processing-instruction()">
	<xsl:text>
	</xsl:text>
	<x:copy>
	  <xsl:text>
	  </xsl:text>
	  <x:apply-templates select="@*|node()"/>
	  <xsl:text>
	  </xsl:text>
	</x:copy>
	<xsl:text>
	</xsl:text>
      </x:template>
      <xsl:text>
      </xsl:text>
    </x:stylesheet>
  </xsl:template>
  <xsl:template match="text()">
    <x:text><xsl:value-of select="." /></x:text>
  </xsl:template>
  <xsl:template match="*|@*|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
