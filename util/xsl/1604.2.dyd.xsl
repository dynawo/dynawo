<!--  This xsl:
    * rename tapChangerLock_lockedT in tapChangerBlocking_blockedT
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
    <xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
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

    <xsl:template match="@var1">
        <xsl:variable name="name" select="."/>
        <xsl:attribute name="var1">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$name" />
                <xsl:with-param name="replace" select="'tapChangerLock_lockedT'" />
                <xsl:with-param name="by" select="'tapChangerBlocking_blockedT'" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@var2">
        <xsl:variable name="name" select="."/>
        <xsl:attribute name="var2">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$name" />
                <xsl:with-param name="replace" select="'tapChangerLock_lockedT'" />
                <xsl:with-param name="by" select="'tapChangerBlocking_blockedT'" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
