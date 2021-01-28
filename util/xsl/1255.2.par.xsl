<!--  This xsl:
    * removes the maxRootRestart, nEff, nDeadband and recalculateStep from the solvers set of parameters
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

    <xsl:template match="dyn:par">
        <xsl:choose>
            <xsl:when test="@name='maxRootRestart' or @name='nEff' or @name='nDeadband' or @name='recalculateStep'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace-->
    <xsl:template match="par">
        <xsl:choose>
            <xsl:when test="@name='maxRootRestart' or @name='nEff' or @name='nDeadband' or @name='recalculateStep'"></xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
