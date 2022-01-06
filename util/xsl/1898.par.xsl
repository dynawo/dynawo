<!--  This xsl:
    * for DynaFlow Hvdc
        - adds U1Ref0Pu, Q1Ref0Pu, U2Ref0Pu, Q2Ref0Pu parameters
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>

<!--  These lines enable to avoid empty lines after removing some elements while keeping the indentation fine -->
<xsl:strip-space elements="*"/>

<!--  This first template copies all the xml. It will be overrided by the following templates when they could be applied -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--  To deal with file containing dynawo namespace -->
<!--  We go through all the par entries of each set: <par type="" ... />
        * If the par name corresponds to one of the rule on names, we apply a treatment. Otherwise we just copy the par.
 -->
<xsl:template match="dyn:par">
  <xsl:choose>
    <xsl:when test="@name='hvdc_modeU20' and not(../dyn:reference[@name='hvdc_U1Ref0Pu']) and (../dyn:reference[@name='hvdc_P10Pu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_U1Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">v1_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_U2Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">v2_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_Q1Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">q1_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_Q2Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">q2_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='hvdc_modeU20' and not(../dyn:reference[@name='hvdc_U1Ref0Pu']) and not(../dyn:reference[@name='hvdc_P10Pu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_U1Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../dyn:par[@name='hvdc_U10Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_U2Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../dyn:par[@name='hvdc_U20Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_Q1Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../dyn:par[@name='hvdc_Q10Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_Q2Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../dyn:par[@name='hvdc_Q20Pu']/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="par">
  <xsl:choose>
    <xsl:when test="@name='hvdc_modeU20' and not(../reference[@name='hvdc_U1Ref0Pu']) and (../reference[@name='hvdc_P10Pu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_U1Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">v1_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_U2Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">v2_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_Q1Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">q1_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
      <xsl:element name="reference" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="name">hvdc_Q2Ref0Pu</xsl:attribute>
        <xsl:attribute name="origData">IIDM</xsl:attribute>
        <xsl:attribute name="origName">q2_pu</xsl:attribute>
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='hvdc_modeU20' and not(../reference[@name='hvdc_U1Ref0Pu']) and not(../reference[@name='hvdc_P10Pu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_U1Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../par[@name='hvdc_U10Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_U2Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../par[@name='hvdc_U20Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_Q1Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../par[@name='hvdc_Q10Pu']/@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">hvdc_Q2Ref0Pu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="../par[@name='hvdc_Q20Pu']/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
