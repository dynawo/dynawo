<!--  This xsl:
    * for Network parameters
        - adds disable_internal_phaseTapChanger boolean
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
    <xsl:when test="@name='transformer_tolV' and not(../dyn:par[@name='transformer_disable_internal_phaseTapChanger'])">
      <xsl:copy-of select="."/>
        <xsl:for-each select="//dyn:reference[@name='phaseShifter_tap0']">
          <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
            <xsl:attribute name="type">BOOL</xsl:attribute>
            <xsl:attribute name="name"><xsl:value-of select="./@componentId"></xsl:value-of>_disable_internal_phaseTapChanger</xsl:attribute>
            <xsl:attribute name="value">true</xsl:attribute>
          </xsl:element>
      </xsl:for-each>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">BOOL</xsl:attribute>
        <xsl:attribute name="name">transformer_disable_internal_phaseTapChanger</xsl:attribute>
        <xsl:attribute name="value">false</xsl:attribute>
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
    <xsl:when test="@name='transformer_tolV' and not(../par[@name='transformer_disable_internal_phaseTapChanger'])">
      <xsl:copy-of select="."/>
        <xsl:for-each select="//dyn:reference[@name='phaseShifter_tap0']">
          <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
            <xsl:attribute name="type">BOOL</xsl:attribute>
            <xsl:attribute name="name"><xsl:value-of select="./@componentId"></xsl:value-of>_disable_internal_phaseTapChanger</xsl:attribute>
            <xsl:attribute name="value">true</xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">BOOL</xsl:attribute>
        <xsl:attribute name="name">transformer_disable_internal_phaseTapChanger</xsl:attribute>
        <xsl:attribute name="value">false</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
