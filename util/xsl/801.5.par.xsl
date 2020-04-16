<!--  This xsl:
    * drops a set containing par with UNom, SNom, BShuntPu, Lambda and Kp
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

    <!--  To deal with file containing dynawo namespace -->
    <xsl:template match="dyn:set">
        <xsl:choose>
            <xsl:when test="./*[1]/@name='UNom' and ./*[2]/@name='SNom' and ./*[3]/@name='BShuntPu' and ./*[4]/@name='Lambda' and ./*[5]/@name='Kp'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace -->
    <xsl:template match="set">
        <xsl:choose>
            <xsl:when test="./*[1]/@name='UNom' and ./*[2]/@name='SNom' and ./*[3]/@name='BShuntPu' and ./*[4]/@name='Lambda' and ./*[5]/@name='Kp'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
