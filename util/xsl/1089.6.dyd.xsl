<!--  This xsl works for modelicaModel and modelTemplate:
    * adds a unitDynamicModel switchOff
    * adds a connect between the switchOff running and the generator running variables
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

<xsl:template match="dyn:modelicaModel[dyn:unitDynamicModel[@id='generator' and not(../dyn:unitDynamicModel[@id='switchOff'])]]">
  <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="dyn:unitDynamicModel">
       <xsl:attribute name="id">switchOff</xsl:attribute>
       <xsl:attribute name="name">Dynawo.Electrical.Controls.SwitchOff.SwitchOffGenerator</xsl:attribute>
     </xsl:element>
     <xsl:element name="dyn:connect">
       <xsl:attribute name="id1">switchOff</xsl:attribute>
       <xsl:attribute name="var1">running</xsl:attribute>
       <xsl:attribute name="id2">generator</xsl:attribute>
       <xsl:attribute name="var2">running</xsl:attribute>
     </xsl:element>
  </xsl:copy>
</xsl:template>

<xsl:template match="dyn:modelTemplate[dyn:unitDynamicModel[@id='generator' and not(../dyn:unitDynamicModel[@id='switchOff'])]]">
  <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="dyn:unitDynamicModel">
       <xsl:attribute name="id">switchOff</xsl:attribute>
       <xsl:attribute name="name">Dynawo.Electrical.Controls.SwitchOff.SwitchOffGenerator</xsl:attribute>
     </xsl:element>
     <xsl:element name="dyn:connect">
       <xsl:attribute name="id1">switchOff</xsl:attribute>
       <xsl:attribute name="var1">running</xsl:attribute>
       <xsl:attribute name="id2">generator</xsl:attribute>
       <xsl:attribute name="var2">running</xsl:attribute>
     </xsl:element>
  </xsl:copy>
</xsl:template>


<!--  To deal with file without namespace-->

<xsl:template match="modelicaModel[unitDynamicModel[@id='generator' and not(../unitDynamicModel[@id='switchOff'])]]">
  <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="unitDynamicModel">
       <xsl:attribute name="id">switchOff</xsl:attribute>
       <xsl:attribute name="name">Dynawo.Electrical.Controls.SwitchOff.SwitchOffGenerator</xsl:attribute>
     </xsl:element>
     <xsl:element name="connect">
       <xsl:attribute name="id1">switchOff</xsl:attribute>
       <xsl:attribute name="var1">running</xsl:attribute>
       <xsl:attribute name="id2">generator</xsl:attribute>
       <xsl:attribute name="var2">running</xsl:attribute>
     </xsl:element>
  </xsl:copy>
</xsl:template>

<xsl:template match="modelTemplate[unitDynamicModel[@id='generator' and not(../unitDynamicModel[@id='switchOff'])]]">
  <xsl:copy>
     <xsl:apply-templates select="@*|node()"/>
     <xsl:element name="unitDynamicModel">
       <xsl:attribute name="id">switchOff</xsl:attribute>
       <xsl:attribute name="name">Dynawo.Electrical.Controls.SwitchOff.SwitchOffGenerator</xsl:attribute>
     </xsl:element>
     <xsl:element name="connect">
       <xsl:attribute name="id1">switchOff</xsl:attribute>
       <xsl:attribute name="var1">running</xsl:attribute>
       <xsl:attribute name="id2">generator</xsl:attribute>
       <xsl:attribute name="var2">running</xsl:attribute>
     </xsl:element>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
