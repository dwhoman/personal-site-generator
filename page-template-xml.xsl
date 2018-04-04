<?xml version="1.0"?>
<x:stylesheet version="1.0"
		xmlns:x="http://www.w3.org/1999/XSL/Transform"
		xmlns:xsl="http://www.w3.org/1999/XSL/TransformAlias">
  <x:output method="xml" />
  
  <x:template match="/">
    <x:apply-templates />
  </x:template>

  <x:template match="x:output">
    <x:element name="xsl:output" namespace="http://www.w3.org/1999/XSL/Transform">
      <x:attribute name="method">xml</x:attribute>
      <x:copy-of select="@*[name() != 'method']" />
    </x:element>
  </x:template>
  
  <x:template match="@*|node()">
    <x:copy>
      <x:apply-templates select="@*|node()"/>
    </x:copy>
  </x:template>
</x:stylesheet>
