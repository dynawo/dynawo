<!--  This xsl:
    * renames event_state1 by event_state1_value for load variation events on load_PRefPu
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
            <xsl:when test="../@var1='load_PRefPu'">
                <xsl:variable name="name" select="."/>
                <xsl:attribute name="var2">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$name" />
                        <xsl:with-param name="replace" select="'event_state1'" />
                        <xsl:with-param name="by" select="'event_state1_value'" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@var1">
        <xsl:choose>
            <xsl:when test="../@var2='load_PRefPu'">
                <xsl:variable name="name" select="."/>
                <xsl:attribute name="var1">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$name" />
                        <xsl:with-param name="replace" select="'event_state1'" />
                        <xsl:with-param name="by" select="'event_state1_value'" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
