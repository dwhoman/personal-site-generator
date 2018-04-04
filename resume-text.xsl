<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml">
  <xsl:strip-space elements="*" />
  <xsl:output method="text" indent="no" encoding="utf-8" />
  <xsl:template match="/">
    <xsl:value-of select="//main/h1" />
    <xsl:text>&#xA;========================================</xsl:text>
    <xsl:apply-templates select="//ul[@id='physical-address']" />
    <xsl:apply-templates select="//ul[@id='web-address']" />
    <xsl:apply-templates select="//article" />
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    <xsl:for-each select="li">
      <xsl:text>&#xA;</xsl:text><xsl:apply-templates />
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:value-of select="." />
  </xsl:template>
  <xsl:template match="span[@class='latex-over']">
    <xsl:text> LaTeX</xsl:text>
  </xsl:template>
  <xsl:template match="span[@class='bar-dash']">
    <xsl:text>---</xsl:text>
  </xsl:template>
  <xsl:template match="span[@class='em-dash']">
    <xsl:text>--</xsl:text>
  </xsl:template>
  
  <xsl:template match="a[@class='github'][ancestor::ul[@id='web-address']]">
    <xsl:text>github.com/dwhoman</xsl:text>
  </xsl:template>
  <xsl:template match="a[@class='linkedin']">
    <xsl:text>linkedin.com/in/devin-homan-a78992b7</xsl:text>
  </xsl:template>
  <xsl:template match="a[@class='web-archive']">
    <xsl:value-of select="@href" />
  </xsl:template>
  <xsl:template match="a">
    <xsl:value-of select="text()" />
  </xsl:template>
  
  <xsl:template match="h2">
    <xsl:text>&#xA;&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xA;--------------------</xsl:text>
  </xsl:template>
  <xsl:template match="h3">
    <xsl:text>&#xA;&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  <xsl:template match="hr">
  </xsl:template>
</xsl:stylesheet>
