<!--  This xsl:
    * removes connect between transformer_switchOffSignal1 and NETWORK
    * removes connect between transformerD_switchOffSignal1 and NETWORK
    * removes connect between transformerT_switchOffSignal1 and NETWORK
    * removes connect between tapChanger_switchOffSignal1 and NETWORK
    * removes connect between tapChangerD_switchOffSignal1 and NETWORK
    * removes connect between tapChangerT_switchOffSignal1 and NETWORK
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
    <xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>

    <!--  These lines enable to avoid empty lines after removing some elements while keeping the indentation fine -->
    <xsl:strip-space elements="*"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!--  To deal with file containing dynawo namespace -->
    <xsl:template match="dyn:connect">
        <xsl:choose>
            <xsl:when test="(@var1='transformer_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformer_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='transformerD_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformerD_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='transformerT_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformerT_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChanger_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChanger_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChangerD_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChangerD_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChangerT_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChangerT_switchOffSignal1')"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace-->
    <xsl:template match="connect">
        <xsl:choose>
            <xsl:when test="(@var1='transformer_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformer_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='transformerD_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformerD_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='transformerT_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='transformerT_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChanger_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChanger_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChangerD_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChangerD_switchOffSignal1')"></xsl:when>
            <xsl:when test="(@var1='tapChangerT_switchOffSignal1' and @id2='NETWORK') or (@id1='NETWORK' and @var2='tapChangerT_switchOffSignal1')"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
