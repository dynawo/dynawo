<!--  This xsl:
    * rename injector in SVarC in a set of par of a StaticVarCompensator, completes 801.6.par but needs to be done separately
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

    <xsl:template match="dyn:set">
        <xsl:choose>
            <xsl:when test="./*[1]/@name='injector_SNom' and ./*[2]/@name='injector_U0Pu' and ./*[3]/@name='injector_UPhase0' and ./*[4]/@name='injector_P0Pu' and ./*[5]/@name='injector_Q0Pu'">
                <xsl:element name="set" xmlns="http://www.rte-france.com/dynawo">
                    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                    <xsl:for-each select="./*">
                        <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                            <xsl:attribute name="type"><xsl:value-of select="./@type"/></xsl:attribute>
                            <xsl:variable name="name" select="./@name"/>
                            <xsl:attribute name="name">
                                <xsl:call-template name="string-replace-all">
                                    <xsl:with-param name="text" select="$name"/>
                                    <xsl:with-param name="replace" select="'injector'"/>
                                    <xsl:with-param name="by" select="'SVarC'" />
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="./@value"/></xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
