<!--  This xsl:
    * rework order of outputs entries in job
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:strip-space elements="*"/>

<xsl:template match="dyn:outputs">
  <xsl:copy>
    <!-- copy all attributes -->
    <xsl:apply-templates select="@*" />
    <!-- apply order -->
    <xsl:apply-templates select="dyn:dumpInitValues"/>
    <xsl:apply-templates select="dyn:constraints"/>
    <xsl:apply-templates select="dyn:timeline"/>
    <xsl:apply-templates select="dyn:timetable"/>
    <xsl:apply-templates select="dyn:finalState"/>
    <xsl:apply-templates select="dyn:curves"/>
    <xsl:apply-templates select="dyn:lostEquipments"/>
    <xsl:apply-templates select="dyn:logs"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="outputs">
  <xsl:copy>
    <!-- copy all attributes -->
    <xsl:apply-templates select="@*" />
    <!-- apply order -->
    <xsl:apply-templates select="dumpInitValues"/>
    <xsl:apply-templates select="constraints"/>
    <xsl:apply-templates select="timeline"/>
    <xsl:apply-templates select="timetable"/>
    <xsl:apply-templates select="finalState"/>
    <xsl:apply-templates select="curves"/>
    <xsl:apply-templates select="lostEquipments"/>
    <xsl:apply-templates select="logs"/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>
