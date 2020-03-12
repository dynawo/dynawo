<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--  To deal with file containing dynawo namespace -->
<xsl:template match="dyn:par">
    <xsl:copy-of select="."/>
    <xsl:if test="@name='PNom' and preceding-sibling::dyn:par[1]/@name = 'SNom'">
      <xsl:text>
      </xsl:text>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">PNomAlt</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
      </xsl:element>
    </xsl:if>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="par">
    <xsl:copy-of select="."/>
    <xsl:if test="@name='PNom' and preceding-sibling::par[1]/@name = 'SNom'">
      <xsl:text>
      </xsl:text>
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">PNomAlt</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
      </xsl:element>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
