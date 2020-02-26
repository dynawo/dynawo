<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" />
  </xsl:copy>
</xsl:template>

<xsl:template match="dyn:simulation[@activateCriteria]">
    <xsl:if test="@activateCriteria ='false'">
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name( ) != 'activateCriteria']"/>
        </xsl:copy>
    </xsl:if>
    <xsl:if test="@activateCriteria ='true'">
        <xsl:copy>
            <xsl:apply-templates select="@*[local-name( ) != 'activateCriteria']"/>
            <xsl:text>
            </xsl:text>
            <xsl:element name="dyn:criteria">
              <xsl:attribute name="criteriaFile">criteria.crt</xsl:attribute>
            </xsl:element>
            <xsl:text>
            </xsl:text>
        </xsl:copy>
    </xsl:if>
</xsl:template>
</xsl:stylesheet>
