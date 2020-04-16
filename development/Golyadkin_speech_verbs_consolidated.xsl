<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kiun="http://kiun.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="speeches" as="element(ex)+" select="//ex"/>
    <xsl:variable name="transes" as="xs:string+" select="distinct-values($speeches/@trans)"/>
    <!--14-->
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

    <!-- functions -->
    <xsl:function name="kiun:createBar" as="element()+">
        <xsl:param name="verb" as="xs:string"/>
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:param name="color" as="xs:string"/>
        <xsl:variable name="yPos" as="xs:double"
            select="$pos * $yScale * ($barHeight + $interbarSpacing)"/>
        <rect x="0" y="-{$yPos}" width="{count($speeches[@trans eq $verb]) * $xScale}"
            height="{$barHeight * $yScale}" fill="{$color}"/>
        <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
            alignment-baseline="middle">
            <xsl:value-of select="$verb"/>
        </text>
    </xsl:function>

    <!--x axis and y axis-->
    <line x1="0" y1="0" x2="0" y2="-{$chartHeight + ($interbarSpacing * $yScale)}" stroke="black"
        stroke-linecap="square"/>
    <line x1="0" y1="0" x2="{$maxCount * $xScale + ($xScale div 2)}" y2="0" stroke="black"
        stroke-linecap="square"/>

    <!-- vertical ruling lines and numerals-->
    <xsl:template match="/">
        <svg height="{$chartHeight + 120}">
            <g transform="translate(200, {$chartHeight + 50})">
                <xsl:for-each select="0 to xs:integer($maxCount idiv 5)">
                    <xsl:variable name="xPos" as="xs:integer" select=". * $xScale * 5"/>
                    <line x1="{$xPos}" y1="0" x2="{$xPos}"
                        y2="-{$chartHeight + ($interbarSpacing * $yScale)}" stroke="lightgray"/>
                    <text x="{$xPos}" y="20" text-anchor="middle">
                        <xsl:value-of select=". * 5"/>
                    </text>
                </xsl:for-each>
                <!-- Y position is determined by verbs -->
                <!-- I am trying to put them in order of loudness of speaking acts (and addressability?) -->
                <!-- Then, according to addressability(?), fill the bars with different colors  -->
                <!-- horizontal ruling lines and verbs-->
                <!--<xsl:for-each select="'shout', 'order', 'answer', 'ask'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:double+"
                        select="
                            (13, 12, 11, 10)[$position] *
                            $yScale * ($barHeight + $interbarSpacing)
                            "/>
                    <rect x="0" y="-{$yPos}"
                        width="{count($speeches[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="red"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>-->
                <xsl:for-each select="'shout', 'order', 'answer', 'ask'">
                    <xsl:sequence select="kiun:createBar(current(), 14 - position(), 'red')"/>
                </xsl:for-each>
                <xsl:for-each select="'talk', 'continue'">
                    <xsl:sequence select="kiun:createBar(current(), 10 - position(), 'pink')"/>
                </xsl:for-each>
                <xsl:for-each select="'grumble', 'murmur', 'whisper'">
                    <xsl:sequence select="kiun:createBar(current(), 8 - position(), 'orange')"/>
                </xsl:for-each>
                <xsl:for-each select="'talk to himself', 'murmur to himself', 'whisper'">
                    <xsl:sequence select="kiun:createBar(current(), 5 - position(), 'turquoise')"/>
                </xsl:for-each>
                <xsl:for-each select="'think'">
                    <xsl:sequence select="kiun:createBar(current(), 2 - position(), 'blue')"/>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
