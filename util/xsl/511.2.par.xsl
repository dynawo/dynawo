<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--  To deal with file containing dynawo namespace -->
<xsl:template match="@name">
  <xsl:attribute name="name">
    <xsl:choose>
      <xsl:when test=". = 'PNom' and ../preceding-sibling::dyn:par[1]/@name = 'SNom'">PNomTurb</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="@name">
  <xsl:attribute name="name">
    <xsl:choose>
      <xsl:when test=". = 'PNom' and ../preceding-sibling::par[1]/@name = 'SNom'">PNomTurb</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>
