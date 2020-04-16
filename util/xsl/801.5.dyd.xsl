<!--  This xsl:
    * drops unitDynamicModel Dynawo.Electrical.Controls.Voltage.StaticVarCompensator.SVarCControl
    * drops connect containing BPu, GPu, UPu and QInjPu for svarcControl
    * drops initConnect containing B0Pu, G0Pu, U0Pu, Q0Pu for svarcControl
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
    <xsl:template match="dyn:unitDynamicModel">
        <xsl:choose>
            <xsl:when test="@name='Dynawo.Electrical.Controls.Voltage.StaticVarCompensator.SVarCControl'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dyn:initConnect">
        <xsl:choose>
            <xsl:when test="@id2='svarcControl' and @var2='B0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='G0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='U0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='Q0Pu'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="dyn:connect">
        <xsl:choose>
            <xsl:when test="@id2='svarcControl' and @var2='BPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='GPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='UPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='QInjPu'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  To deal with file without namespace-->
    <xsl:template match="unitDynamicModel">
        <xsl:choose>
            <xsl:when test="@name='Dynawo.Electrical.Controls.Voltage.StaticVarCompensator.SVarCControl'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="initConnect">
        <xsl:choose>
            <xsl:when test="@id2='svarcControl' and @var2='B0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='G0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='U0Pu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='Q0Pu'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="connect">
        <xsl:choose>
            <xsl:when test="@id2='svarcControl' and @var2='BPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='GPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='UPu'"></xsl:when>
            <xsl:when test="@id2='svarcControl' and @var2='QInjPu'"></xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
