<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- stylesheet variables -->
    <xsl:variable name="root" as="document-node()" select="/"/>
    <xsl:variable name="allSpeakers" as="xs:string+"
        select="distinct-values(//@whose) ! lower-case(.) => sort()"/>
    <xsl:variable name="allKeywords" as="xs:string+"
        select="distinct-values(//@to)"/>
    <xsl:variable name="nameLookup" as="map(*)"
        select="
        map{
        'petru' : 'Petrushka',
        'doub' : 'Double',
        'nar' : 'Narrator',
        'gol' : 'Goliadkin',
        'kre' : 'Krestian Ivanovich'}
        "/>
    <xsl:variable name="colorsBySpeaker" as="map(*)"
        select="
        map{
        'gol' : 'red',
        'doub' : 'magenta',
        'nar' : 'blue',
        'kre' : 'green',
        'petru' : 'orange'
        }"/>
    <xsl:variable name="yScale" as="xs:integer" select="80"/>
    <xsl:variable name="barShift" as="xs:integer" select="70"/>
    <xsl:variable name="barScale" as="xs:integer" select="20"/>
    <!-- end of stylesheet variables -->
    <xsl:template match="/">
        <svg width="1000" height="750">
            <g transform="translate(10)">
                <xsl:for-each select="$allKeywords">
                    <xsl:sort select="lower-case(.)"/>
                    <xsl:variable name="currentKeyword" as="xs:string" select="."/>
                    <!-- one bar for each keyword -->
                    <xsl:variable name="yPos" as="xs:integer" select="position() * $yScale"/>
                    <text x="0" y="{$yPos + 15}">
                        <xsl:value-of select="."/>
                    </text>
                    <xsl:for-each select="$root//ref[@to eq current() and @whose]">
                        <xsl:variable name="currentSpeaker" as="attribute(whose)" select="@whose"/>
                        <xsl:variable name="currentRefChapter" as="element(chapter)"
                            select="ancestor::chapter"/>
                        <xsl:variable name="prevRefChapter" as="element(chapter)?"
                            select="preceding::ref[@to eq $currentKeyword][1]/ancestor::chapter"/>
                        <xsl:variable name="xPos" as="xs:integer"
                            select="position() * $barScale + $barShift"/>
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
                <!-- legend -->
                <!-- what I had in mind is to write a legend in a row horizontally right beneath the last bar of the scheme -->
                <g transform="translate(10, {(count($allKeywords) + 1) * $yScale})">
                    <rect x="0" y="-10" width="180" height="{count($allSpeakers) * 30 + 10}" fill="none"
                        stroke="black" stroke-width="1"/>
                    <xsl:for-each select="$allSpeakers">
                        <xsl:variable name="yPos" as="xs:integer" select="(position() - 1) * 30"/>
                        <rect x="10" y="{$yPos}" height="20" width="20" fill="{$colorsBySpeaker(.)}"/>
                        <text x="40" y="{$yPos + 10}" alignment-baseline="central">
                            <xsl:value-of select="$nameLookup(.)"/>
                        </text>
                    </xsl:for-each>
                </g>
            </g>
        </svg>
        <xsl:message select="$allSpeakers"/>
    </xsl:template>
</xsl:stylesheet>
<!--  <xsl:for-each select="distinct-values(//@to)[not(. eq 'сиамские близнецы')]"> -->
<!--    <xsl:variable name="allSpeakers" as="xs:string+"
        select="distinct-values(//@whose) ! lower-case(.) => sort()"/>   
    <xsl:variable name="allKeywords" as="xs:string+"
        select="distinct-values(//@to)[. ne 'сиамские близнецы']"/> -->
