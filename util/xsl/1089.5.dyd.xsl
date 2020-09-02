<!--  This xsl works with connects between transformer and tapChanger and:
    * renames transformer_switchOffSignal1 in transformer_running and tapChanger_switchOffSignal1 in tapChanger_running
    * renames transformerT_switchOffSignal1 in transformerT_running and tapChanger_switchOffSignal1 in tapChanger_running
    * renames transformerD_switchOffSignal1 in transformerD_running and tapChanger_switchOffSignal1 in tapChanger_running
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
<xsl:template match="dyn:connect[@var1='transformer_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformer_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="dyn:connect[@var1='transformerT_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformerT_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="dyn:connect[@var1='transformerD_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformerD_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="dyn:connect[@var1='tapChanger_switchOffSignal1' and @var2='transformer_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformer_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="dyn:connect[@var1='tapChanger_switchOffSignal1' and @var2='transformerT_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformerT_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="dyn:connect[@var1='tapChanger_switchOffSignal1' and @var2='transformerD_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformerD_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


<!--  To deal with file without namespace-->
<xsl:template match="connect[@var1='transformer_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformer_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="connect[@var1='transformerT_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformerT_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="connect[@var1='transformerD_switchOffSignal1' and @var2='tapChanger_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">transformerD_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">tapChanger_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="connect[@var1='tapChanger_switchOffSignal1' and @var2='transformer_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformer_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="connect[@var1='tapChanger_switchOffSignal1' and @var2='transformerT_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformerT_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
<xsl:template match="connect[@var1='tapChanger_switchOffSignal1' and @var2='transformerD_switchOffSignal1']">
  <xsl:copy>
    <xsl:attribute name="id1"><xsl:value-of select="@id1"/></xsl:attribute>
    <xsl:attribute name="var1">tapChanger_running</xsl:attribute>
    <xsl:attribute name="id2"><xsl:value-of select="@id2"/></xsl:attribute>
    <xsl:attribute name="var2">transformerD_running</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
