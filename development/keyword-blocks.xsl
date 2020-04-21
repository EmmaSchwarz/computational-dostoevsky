<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- stylesheet variables -->
    <xsl:variable name="root" as="document-node()" select="/"/>
    <xsl:variable name="colorsBySpeaker" as="map(*)"
        select="
        map{
        'gol' : 'magenta',
        'doub' : 'blue',
        'nar' : 'red',
        'kre' : 'green',
        'petru' : 'orange'
        }"/>
    <!-- end of stylesheet variables -->

    <xsl:template match="/">
        <svg height="600">
            <g transform="translate(10)">
                <xsl:for-each select="distinct-values(//@to)[not(. eq 'сиамские близнецы')]">
                    <xsl:sort select="lower-case(.)"/>
                    <xsl:variable name="currentKeyword" as="xs:string" select="."/>
                    <!-- one bar for each keyword -->
                    <xsl:variable name="yPos" as="xs:integer" select="position() * 80"/>
                    <text x="0" y="{$yPos + 15}">
                        <xsl:value-of select="."/>
                    </text>
                    <xsl:for-each select="$root//ref[@to eq current() and @whose]">
                        <xsl:variable name="currentSpeaker" as="attribute(whose)" select="@whose"/>
                        <xsl:variable name="currentRefChapter" as="element(chapter)"
                            select="ancestor::chapter"/>
                        <xsl:variable name="prevRefChapter" as="element(chapter)?"
                            select="preceding::ref[@to eq $currentKeyword][1]/ancestor::chapter"/>
                        <xsl:variable name="xPos" as="xs:integer" select="position() * 20 + 70"/>
                        <!-- print chapter number if first or different from preceding -->
                        <rect x="{$xPos}" y="{$yPos}" width="20" height="20"
                            fill="{$colorsBySpeaker(@whose)}"/>
                        <xsl:if
                            test="position() eq 1 or $currentRefChapter/@id != $prevRefChapter/@id">
                            <text x="{$xPos}" y="{$yPos + 35}" text-anchor="middle"
                                font-size="smaller">
                                <xsl:value-of select="$currentRefChapter/@id ! substring(., 3)"/>
                            </text>
                            <line x1="{$xPos}" y1="{$yPos}" x2="{$xPos}" y2="{$yPos + 20}"
                                stroke="black" stroke-width="2"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
