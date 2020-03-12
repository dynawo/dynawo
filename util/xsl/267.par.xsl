<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@name">
  <xsl:attribute name="name">
    <xsl:choose>
      <xsl:when test=". = 'LOAD_alpha'">load_alpha</xsl:when>
      <xsl:when test=". = 'LOAD_beta'">load_beta</xsl:when>
      <xsl:when test=". = 'LOAD_isRestorative'">load_isRestorative</xsl:when>
      <xsl:when test=". = 'LOAD_isControllable'">load_isControllable</xsl:when>
      <xsl:when test=". = 'LOAD_Tp'">load_Tp</xsl:when>
      <xsl:when test=". = 'LOAD_Tq'">load_Tq</xsl:when>
      <xsl:when test=". = 'LOAD_zPMax'">load_zPMax</xsl:when>
      <xsl:when test=". = 'LOAD_zQMax'">load_zQMax</xsl:when>
      <xsl:when test=". = 'LOAD_alphaLong'">load_alphaLong</xsl:when>
      <xsl:when test=". = 'LOAD_betaLong'">load_betaLong</xsl:when>
      <xsl:when test=". = 'TFO_currentLimit_maxTimeOperation'">transformer_currentLimit_maxTimeOperation</xsl:when>
      <xsl:when test=". = 'TFO_t1st_THT'">transformer_t1st_THT</xsl:when>
      <xsl:when test=". = 'TFO_tNext_THT'">transformer_tNext_THT</xsl:when>
      <xsl:when test=". = 'TFO_t1st_HT'">transformer_t1st_HT</xsl:when>
      <xsl:when test=". = 'TFO_tNext_HT'">transformer_tNext_HT</xsl:when>
      <xsl:when test=". = 'TFO_tolV'">transformer_tolV</xsl:when>
      <xsl:when test=". = 'BUS_uMax'">bus_uMax</xsl:when>
      <xsl:when test=". = 'BUS_uMin'">bus_uMin</xsl:when>
      <xsl:when test=". = 'LINE_currentLimit_maxTimeOperation'">line_currentLimit_maxTimeOperation</xsl:when>
      <xsl:when test=". = 'CAPACITOR_no_reclosing_delay'">capacitor_no_reclosing_delay</xsl:when>
      <xsl:when test=". = 'REACTANCE_no_reclosing_delay'">reactance_no_reclosing_delay</xsl:when>
      <xsl:when test=". = 'DANGLING_LINE_currentLimit_maxTimeOperation'">dangling_line_currentLimit_maxTimeOperation</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>
</xsl:stylesheet>
