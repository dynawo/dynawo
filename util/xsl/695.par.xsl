<!--  This xsl:
    * for simplified generators (PV,PQ)
        - replaces the AlphaPu by an AlphaPuPNom (= AlphaPu * SnRef / PNom)
        - creates a PNom parameter
        - replaces PMinPu and PMaxPu parameters by references to IIDM values
    * for PV generators only:
        - replaces the LambdaPu by a LambdaPuSNom (= LambdaPu * SNom / SnRef)
        - creates a SNom parameter
        - replaces QMinPu and QMaxPu by QMin and QMax (= QMin * SnRef)
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
        * For PMinPu, QMinPu and QMaxPu, it is quite simple: we multiply by 100.
        * For PMaxPu, we use it to create PNom and if necessary SNom. It is also modified and multiplied by 100.
        * For AlphaPu and LambdaPu, we replace it by a new attribute AlphaPuPNom or LambdaPuSNom and use the value of PMaxPu to calculate it.
          (we go back to the set and then comes back to PMaxPu to be sure that we take the PMaxPu from the set and not the first PMaxPu of the file.
 -->
<xsl:template match="dyn:par">
  <xsl:choose>
    <xsl:when test="@name='generator_AlphaPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_AlphaPuPNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value div ancestor::dyn:set/dyn:par[@name='generator_PMaxPu']/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_PMinPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PMin</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_PMaxPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PMax</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
      <xsl:if test="ancestor::dyn:set/dyn:par[@name='generator_LambdaPu']">
        <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
          <xsl:attribute name="type">DOUBLE</xsl:attribute>
          <xsl:attribute name="name">generator_SNom</xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="@value * 1.04 * 100"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:when>
    <xsl:when test="@name='generator_LambdaPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_LambdaPuSNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value div (1.04 * ancestor::dyn:set/dyn:par[@name='generator_PMaxPu']/@value)"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_QMinPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_QMin</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_QMaxPu'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_QMax</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
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
    <xsl:when test="@name='generator_AlphaPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_AlphaPuPNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value div ancestor::set/par[@name='generator_PMaxPu']/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_PMinPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PMin</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_PMaxPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PMax</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
      <xsl:if test="ancestor::dyn:set/dyn:par[@name='generator_LambdaPu']">
        <xsl:element name="par">
          <xsl:attribute name="type">DOUBLE</xsl:attribute>
          <xsl:attribute name="name">generator_SNom</xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="@value * 1.04 * 100"/></xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:when>
    <xsl:when test="@name='generator_LambdaPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_LambdaPuSNom</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value div 1.04 * ancestor::set/par[@name='generator_PMaxPu']/@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_QMinPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_QMin</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_QMaxPu'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_QMax</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value * 100"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
