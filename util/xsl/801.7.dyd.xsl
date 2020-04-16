<!--  This xsl:
    * rename injector in SVarC in connect
    * rename svarcControl in svarc
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
    <xsl:template match="@var2">
        <xsl:choose>
            <xsl:when test="../@id2='SVarC'">
                <xsl:variable name="name" select="."/>
                <xsl:attribute name="var2">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$name" />
                        <xsl:with-param name="replace" select="'injector'" />
                        <xsl:with-param name="by" select="'SVarC'" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@id2">
        <xsl:variable name="name" select="."/>
        <xsl:attribute name="id2">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$name" />
                <xsl:with-param name="replace" select="'svarcControl'" />
                <xsl:with-param name="by" select="'svarc'" />
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
