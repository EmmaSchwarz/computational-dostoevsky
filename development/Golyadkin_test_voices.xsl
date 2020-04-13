<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>


    <!--The ultimate graph I was thinking about for the assignment was to have each chapter and the frequency of speech in each axis and then, 
        to produce several lines for each character, who are Goliadkin's internalized or externalized consciousness. 
        
        THe Question I had was: 
        is there a way to put the two different attributes, @voice and @speaker, in the y axis? 
        I want to compare the frequency of double, narrator, petrushka (which are @speaker category) and timid, confident, mocking (which are @voice category),
        and align them in the one axis.
          I tried to put @voice and @speaker in select attribute of line 12 and group-by of line 37, but of course it did not work.
          " -->
    
    <xsl:variable name="sprNumber" as="xs:string+" select="distinct-values(//@voice)"/> 
    <xsl:variable name="barHeight" as="xs:integer" select="5"/>
    <xsl:variable name="interbarSpacing" as="xs:double" select="$barHeight div 2"/>
    <xsl:variable name="yScale" as="xs:integer" select="10"/>
    <xsl:variable name="xScale" as="xs:integer" select="20"/>
    <xsl:variable name="chartHeight" as="xs:double"
        select="count($sprNumber) * ($barHeight + $interbarSpacing) * $yScale"/>
    <xsl:variable name="maxCount" as="xs:double"
        select="max(for $i in distinct-values(//@voice)
        return
        count(//speech[@voice eq $i]))"/>
   
    <h1>Frequency of Speech by Goliadkin</h1>
    <xsl:template match="/">
        <svg height="{$chartHeight + 120}">
            <g transform="translate(100, {$chartHeight + 100})">
                <xsl:for-each select="1 to xs:integer($maxCount)">
                    <xsl:variable name="xPos" as="xs:integer" select=". * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{. * $xScale}"
                        y2="-{$chartHeight + ($interbarSpacing * $yScale)}" stroke="lightgray"/>
                    <text x="{$xPos}" y="20" text-anchor="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>
                
                <xsl:for-each-group select="//speech" group-by="@voice">
                <xsl:sort select="current-grouping-key()" order="descending"/>
                    <xsl:variable name="yPos"
                        select="position() * ($barHeight + $interbarSpacing) * $yScale"/>
                    <rect x="0" y="-{$yPos}" width="{count(current-group()) * $xScale}"
                        height="{$barHeight * $yScale}" fill="blue"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="current-grouping-key()"/>
                    </text>
                </xsl:for-each-group>
                
                
                <line x1="0" y1="0" x2="0" y2="-{$chartHeight + ($interbarSpacing * $yScale)}"
                    stroke="black" stroke-linecap="square"/>
                <line x1="0" y1="0" x2="{$maxCount * $xScale + ($xScale div 2)}" y2="0"
                    stroke="black" stroke-linecap="square"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>