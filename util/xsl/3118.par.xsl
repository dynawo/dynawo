<!--  This xsl:
    * for DYNModelAreaShedding
        - adds PShed_ and QShed_ parameters
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
  <xsl:variable name="name" select="@name"/>
  <xsl:choose>
    <xsl:when test="contains(@name,'deltaQ_') and (../dyn:par[@name='nbLoads']) and (../dyn:par[@name='deltaTime']) and not ((../dyn:par[contains(@name,'QShed')]) or (../dyn:par[contains(@name,'PShed')]))">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('PShed',substring ($name ,7))" />
        </xsl:attribute>
        <xsl:attribute name="value">0.</xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('QShed',substring ($name ,7))" />
        </xsl:attribute>
        <xsl:attribute name="value">0.</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="par">
  <xsl:variable name="name" select="@name"/>
  <xsl:choose>
    <xsl:when test="contains(@name,'deltaQ_') and (../dyn:par[@name='nbLoads']) and (../dyn:par[@name='deltaTime']) and not ((../dyn:par[contains(@name,'QShed')]) or (../dyn:par[contains(@name,'PShed')]))">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('PShed',substring ($name ,7))" />
        </xsl:attribute>
        <xsl:attribute name="value">0.</xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('QShed',substring ($name ,7))" />
        </xsl:attribute>
        <xsl:attribute name="value">0.</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
