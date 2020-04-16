<!--  This xsl:
    * merge two sets of parameters for StaticVarCompensator after a huge change in preassembled model where controls are now part of the model
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
            <xsl:when test="./*[1]/@name='SNom' and ./*[2]/@name='U0Pu' and ./*[3]/@name='UPhase0' and ./*[4]/@name='P0Pu' and ./*[5]/@name='Q0Pu'">
                <xsl:element name="set" xmlns="http://www.rte-france.com/dynawo">
                    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                    <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                        <xsl:attribute name="type"><xsl:value-of select="./*[2]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[2]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[2]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                        <xsl:attribute name="type"><xsl:value-of select="./*[3]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[3]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[3]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                        <xsl:attribute name="type"><xsl:value-of select="./*[4]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[4]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[4]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                        <xsl:attribute name="type"><xsl:value-of select="./*[5]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[5]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[4]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:for-each select="./following-sibling::*[1]/*">
                        <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
                            <xsl:attribute name="type"><xsl:value-of select="./@type"/></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="./@name"/></xsl:attribute>
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

    <!--  To deal with file without namespace-->
    <xsl:template match="set">
        <xsl:choose>
            <xsl:when test="./*[1]/@name='SNom' and ./*[2]/@name='U0Pu' and ./*[3]/@name='UPhase0' and ./*[4]/@name='P0Pu' and ./*[5]/@name='Q0Pu'">
                <xsl:element name="set">
                    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                    <xsl:element name="par">
                        <xsl:attribute name="type"><xsl:value-of select="./*[2]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[2]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[2]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par">
                        <xsl:attribute name="type"><xsl:value-of select="./*[3]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[3]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[3]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par">
                        <xsl:attribute name="type"><xsl:value-of select="./*[4]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[4]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[4]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="par">
                        <xsl:attribute name="type"><xsl:value-of select="./*[5]/@type"/></xsl:attribute>
                        <xsl:attribute name="name"><xsl:value-of select="./*[5]/@name"/></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="./*[4]/@value"/></xsl:attribute>
                    </xsl:element>
                    <xsl:for-each select="./following-sibling::*[1]/*">
                        <xsl:element name="par">
                            <xsl:attribute name="type"><xsl:value-of select="./@type"/></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="./@name"/></xsl:attribute>
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
