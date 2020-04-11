<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Create horizontal bar chart with horizontal bars                 -->
    <!--                                                                  -->
    <!-- Y axis is distinct @trans value                                  -->
    <!-- X axis is count of occurrences of Y value                        -->
    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $speeches as element(ex)+ : speeches in text                     -->
    <!-- $transes as xs:string+ : distinct @trans values                  -->
    <!-- $barHeight as xs:integer : vertical thickness of bar             -->
    <!-- $interbarSpacing as xs:double : vertical space between bars      -->
    <!-- $yScale as xs:integer : scale all Y values                       -->
    <!-- $xScale as xs:integer : scale all X values                       -->
    <!-- $chartHeight as xs:double : total height (depends on bar count)  -->
    <!-- $maxCount as xs:double : maximum instances of specific @trans    -->
    <!-- ================================================================ -->
    <xsl:variable name="speeches" as="element(ex)+" select="//ex"/>
    <xsl:variable name="transes" as="xs:string+" select="distinct-values($speeches/@trans)"/>
    <xsl:variable name="barHeight" as="xs:integer" select="5"/>
    <xsl:variable name="interbarSpacing" as="xs:double" select="$barHeight div 2"/>
    <xsl:variable name="yScale" as="xs:integer" select="5"/>
    <xsl:variable name="xScale" as="xs:integer" select="20"/>
    <xsl:variable name="chartHeight" as="xs:double"
        select="count($transes) * ($barHeight + $interbarSpacing) * $yScale"/>
    <xsl:variable name="maxCount" as="xs:double"
        select="
            max(for $trans in distinct-values($transes)
            return
                count(//ex[@trans eq $trans]))"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <svg height="{$chartHeight + 120}">
            <g transform="translate(100, {$chartHeight + 50})">
                <!-- ==================================================== -->
                <!-- X axis labels (counts) and ruling lines              -->
                <!-- ==================================================== -->
                <xsl:for-each select="1 to ($maxCount idiv 1)">
                    <xsl:variable name="xPos" as="xs:integer" select=". * $xScale"/>
                    <line x1="{$xPos}" y1="0" x2="{. * $xScale}"
                        y2="-{$chartHeight + ($interbarSpacing * $yScale)}" stroke="lightgray"/>
                    <text x="{$xPos}" y="20" text-anchor="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>
                <!-- ==================================================== -->
                <!-- Bars and Y (@trans) labels                           -->
                <!-- ==================================================== -->
                <xsl:for-each-group select="$speeches" group-by="@trans">
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
                <!-- ==================================================== -->
                <!-- Axes                                                 -->
                <!-- ==================================================== -->
                <line x1="0" y1="0" x2="0" y2="-{$chartHeight + ($interbarSpacing * $yScale)}"
                    stroke="black" stroke-linecap="square"/>
                <line x1="0" y1="0" x2="{$maxCount * $xScale + ($xScale div 2)}" y2="0"
                    stroke="black" stroke-linecap="square"/>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
