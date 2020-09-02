<!--  This xsl works with staticRefs and:
    * renames generator_state in switchOff_state
    * renames load_state in switchOff_state
    * renames transformer_state in switchOff_state
    * renames transformerT_state in switchOff_state
    * renames SVarC_injector_state in switchOff_state
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
<xsl:template match="dyn:staticRef">
  <xsl:choose>
    <xsl:when test="@var='generator_state'">
      <xsl:element name="dyn:staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='load_state'">
      <xsl:element name="dyn:staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='transformer_state'">
      <xsl:element name="dyn:staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='transformerT_state'">
      <xsl:element name="dyn:staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='SVarC_injector_state'">
      <xsl:element name="dyn:staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="staticRef">
  <xsl:choose>
    <xsl:when test="@var='generator_state'">
      <xsl:element name="staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='load_state'">
      <xsl:element name="staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='transformer_state'">
      <xsl:element name="staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='transformerT_state'">
      <xsl:element name="staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var='SVarC_injector_state'">
      <xsl:element name="staticRef">
        <xsl:attribute name="var">switchOff_state</xsl:attribute>
        <xsl:attribute name="staticVar"><xsl:value-of select="@staticVar"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
