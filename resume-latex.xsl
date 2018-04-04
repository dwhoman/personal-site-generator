<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="no" encoding="utf-8" />
  <xsl:template match="/">
    <xsl:text>
      \documentclass[12pt,letterpaper]{article}
      \usepackage[letterpaper, headheight=15pt, margin=1in]{geometry}
      \usepackage{url}
      \usepackage{titlesec}
      \usepackage{fancyhdr}
      \usepackage{titling}
      \titleformat{\section}{\scshape}{\thesection}{0em}{}[{\titlerule[0.6pt]}]
      \titleformat{\subsection}{\scshape}{\thesection}{0em}{}
      \author{}
      \rhead{\thepage}
      \cfoot{}
      \pagestyle{fancy}
      \date{\vspace{-5ex}}
    </xsl:text>
    <xsl:text>\chead{\textsc{</xsl:text><xsl:value-of select="//main/h1" /><xsl:text>}}</xsl:text>
    <xsl:text>\title{\textsc{</xsl:text><xsl:value-of select="//main/h1" /><xsl:text>}}</xsl:text>
    <xsl:text>
      \begin{document}
      \setlength{\droptitle}{-70pt}
      \maketitle
      \vspace{-20pt}
      \thispagestyle{empty}
    </xsl:text>
    <xsl:text>\noindent\begin{minipage}[t]{3in}</xsl:text>
    <xsl:apply-templates select="//ul[@id='physical-address']" />
    <xsl:text>\end{minipage}\hfill</xsl:text>
    <xsl:text>\begin{minipage}[t]{3.5in}</xsl:text>
    <xsl:apply-templates select="//ul[@id='web-address']" />
    <xsl:text>\end{minipage}</xsl:text>
    <xsl:apply-templates select="//article" />
    <xsl:text>
      \end{document}
    </xsl:text>
  </xsl:template>

  <xsl:template match="ul[@id='physical-address' or @id='web-address']">
    <xsl:text>\begin{centering}</xsl:text>
    <xsl:for-each select="li">
      <xsl:apply-templates /><xsl:text>\\</xsl:text>
    </xsl:for-each>
    <xsl:text>\end{centering}</xsl:text>
  </xsl:template>
  <xsl:template match="ul">
    <xsl:text>\begin{itemize}</xsl:text>
    <xsl:for-each select="li">
      <xsl:text>\item[] </xsl:text>
      <xsl:apply-templates />
    </xsl:for-each>
    <xsl:text>\end{itemize}</xsl:text>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="." />
  </xsl:template>
  <xsl:template match="span[@class='latex-over']">
    <xsl:text>{\LaTeX}</xsl:text>
  </xsl:template>
  <xsl:template match="span[@class='bar-dash']">
    <xsl:text>---</xsl:text>
  </xsl:template>
  <xsl:template match="span[@class='em-dash']">
    <xsl:text>--</xsl:text>
  </xsl:template>
  
  <xsl:template match="a[@class='github'][ancestor::ul[@id='web-address']]">
    <xsl:text>\url{github.com/dwhoman}</xsl:text>
  </xsl:template>
  <xsl:template match="a[@class='linkedin']">
    <xsl:text>\url{linkedin.com/in/devin-homan-a78992b7}</xsl:text>
  </xsl:template>
  <xsl:template match="a[@class='web-archive']">
    <xsl:text>\url{</xsl:text><xsl:value-of select="@href" /><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="a">
    <xsl:text>\url{</xsl:text><xsl:value-of select="text()" /><xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template match="h2">
    <xsl:text>\section*{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="h3">
    <xsl:text>\subsection*{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="hr">
  </xsl:template>
</xsl:stylesheet>
