<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- stylesheet variables -->
    <xsl:variable name="root" as="document-node()" select="/"/>
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
        <svg height="600">
            <g transform="translate(10)">
                <xsl:for-each select="distinct-values(//@to)">
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
                        <xsl:variable name="xPos" as="xs:integer" select="position() * $barScale + $barShift"/>
                        
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

<!-- to create a legend for the stacked bargraphs--> 
<!-- what I had in mind is to write a legend in a row horizontally right beneath the last bar of the scheme -->
                        
                        <xsl:variable name="fivespeakers" select="distinct-values(@whose)"/>
                        <xsl:variable name="legendXpos" as="xs:integer" select="(position()* 20 + $barShift)"/>
                        <xsl:for-each select="$fivespeakers">
                            <rect x="{$legendXpos}" y="{$yPos[last()+1]* $yScale}" width="20" height="20"
                                fill="{$colorsBySpeaker(.)}"/>
                            <text x="{$legendXpos + 25}" y="$yPos[last()+1]* $yScale">
                                <xsl:value-of select="$nameLookup(.)"/>
                                </text>
                            </xsl:for-each>
                        
                </xsl:for-each>
                </xsl:for-each>
                
            </g>
        </svg>
        
   
  
    </xsl:template>
</xsl:stylesheet>

<!--  <xsl:for-each select="distinct-values(//@to)[not(. eq 'сиамские близнецы')]"> -->