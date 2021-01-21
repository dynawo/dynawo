<!--  This xsl:
    * removes the set of parameters corresponding to a simplified solver use with step recalculation that is no longer supported and the associated comment
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

    <xsl:template match="comment()[contains(., 'Simplified solver with step recalculation')]" />

    <!--  To deal with file containing dynawo namespace -->
    <xsl:template match="dyn:set">
        <xsl:choose>
            <xsl:when test="./dyn:par[@name='recalculateStep' and @value='true']"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace-->
    <xsl:template match="set">
        <xsl:choose>
            <xsl:when test="./par[@name='recalculateStep'and @value='true']"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
