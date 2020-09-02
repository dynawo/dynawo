<!--  This xsl works with connects and:
    * renames generator_switchOffSignal1 in switchOff_switchOffSignal1 (network connection)
    * renames load_switchOffSignal1 in switchOff_switchOffSignal1 (network connection)
    * renames generator_switchOffSignal2 in switchOff_switchOffSignal2 (event connection)
    * renames load_switchOffSignal2 in switchOff_switchOffSignal2 (event connection)
    * renames line_switchOffSignal2 in switchOff_switchOffSignal2 (event connection)
    * renames generator_switchOffSignal3 in switchOff_switchOffSignal3 (automata connection)
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
<xsl:template match="dyn:connect">
  <xsl:choose>
    <xsl:when test="@var1='generator_switchOffSignal1'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal1</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal1'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal1</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal1'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal1</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal1'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal1</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='line_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='line_switchOffSignal2'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='line_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='line_switchOffSignal2_value'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal3'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal3</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal3'">
      <xsl:element name="dyn:connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal3</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="connect">
  <xsl:choose>
    <xsl:when test="@var1='generator_switchOffSignal1'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal1</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal1'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal1</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal1'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal1</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal1'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal1</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='load_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='load_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='line_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='line_switchOffSignal2'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='line_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal2_value</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='line_switchOffSignal2_value'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal2_value</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var1='generator_switchOffSignal3'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1">switchOff_switchOffSignal3</xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2"><xsl:value-of select="@var2"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@var2='generator_switchOffSignal3'">
      <xsl:element name="connect">
        <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
        <xsl:attribute name="var1"><xsl:value-of select="@var1"/></xsl:attribute>
        <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
        <xsl:attribute name="var2">switchOff_switchOffSignal3</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
