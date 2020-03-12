<!--  This xsl deletes the attributes UMinPu, UMaxPu, QMinPu, QMaxPu from generators par files -->
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
<!--  These templates delete the necessary elements based on their names.
      In order not to delete useful elements for GeneratorPV, an additional test on the absence of generator_LambdaPu is added.-->
<xsl:template match="dyn:par[@name='generator_QMaxPu' and not(preceding-sibling::dyn:par[@name = 'generator_LambdaPu']) and not(following-sibling::dyn:par[@name = 'generator_LambdaPu'])]"/>
<xsl:template match="dyn:par[@name='generator_QMinPu' and not(preceding-sibling::dyn:par[@name = 'generator_LambdaPu']) and not(following-sibling::dyn:par[@name = 'generator_LambdaPu'])]"/>
<xsl:template match="dyn:par[@name='generator_UMaxPu']"/>
<xsl:template match="dyn:par[@name='generator_UMinPu']"/>

<!--  To deal with file without namespace-->
<xsl:template match="par[@name='generator_QMaxPu' and not(preceding-sibling::par[@name = 'generator_LambdaPu']) and not(following-sibling::par[@name = 'generator_LambdaPu'])]"/>
<xsl:template match="par[@name='generator_QMinPu' and not(preceding-sibling::par[@name = 'generator_LambdaPu']) and not(following-sibling::par[@name = 'generator_LambdaPu'])]"/>
<xsl:template match="par[@name='generator_UMaxPu']"/>
<xsl:template match="par[@name='generator_UMinPu']"/>

</xsl:stylesheet>
