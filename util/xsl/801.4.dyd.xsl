<!--  This xsl:
    * rename Dynawo.Electrical.Injectors.InjectorBG_INIT in Dynawo.Electrical.StaticVarCompensators.SVarCStandard_INIT
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
    <xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>

    <!--  These lines enable to avoid empty lines after removing some elements while keeping the indentation fine -->
    <xsl:strip-space elements="*"/>
    <!--  This first template copies all the xml. It will be overridden by the following templates when they could be applied -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@initName">
        <xsl:variable name="initName" select="."/>
        <xsl:attribute name="initName">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$initName" />
                <xsl:with-param name="replace" select="'Dynawo.Electrical.Injectors.InjectorBG_INIT'" />
                <xsl:with-param name="by" select="'Dynawo.Electrical.StaticVarCompensators.SVarCStandard_INIT'" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
