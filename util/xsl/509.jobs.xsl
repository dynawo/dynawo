<!--  This xsl:
    * remove the '.so' and the 'lib' prefix from solver names
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@lib">
  <xsl:attribute name="lib">
    <xsl:choose>
      <xsl:when test=". = 'libdynawo_SolverIDA.so'">dynawo_SolverIDA</xsl:when>
      <xsl:when test=". = 'libdynawo_SolverSIM.so'">dynawo_SolverSIM</xsl:when>
      <xsl:when test=". = 'libdynawo_SolverIDA'">dynawo_SolverIDA</xsl:when>
      <xsl:when test=". = 'libdynawo_SolverSIM'">dynawo_SolverSIM</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>
</xsl:stylesheet>
