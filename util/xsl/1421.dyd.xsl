<!--  This xsl:
    * drops connect containing alphaSum for generator
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
            <xsl:when test="@var1='generator_alphaSum_value'"></xsl:when>
            <xsl:when test="@var1='generator_alphaSum'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace-->

    <xsl:template match="connect">
        <xsl:choose>
            <xsl:when test="@var1='generator_alphaSum_value'"></xsl:when>
            <xsl:when test="@var1='generator_alphaSum'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
