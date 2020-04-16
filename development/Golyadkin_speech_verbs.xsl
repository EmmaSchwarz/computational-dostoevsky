<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="speeches" as="element(ex)+" select="//ex"/>
    <xsl:variable name="transes" as="xs:string+" select="distinct-values($speeches/@trans)"/> <!--14-->
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
 
<!--x axis and y axis-->               
    <line x1="0" y1="0" x2="0" y2="-{$chartHeight + ($interbarSpacing * $yScale)}"
        stroke="black" stroke-linecap="square"/>
    <line x1="0" y1="0" x2="{$maxCount * $xScale + ($xScale div 2)}" y2="0"
        stroke="black" stroke-linecap="square"/>
    
<!-- vertical ruling lines and numerals-->   
    <xsl:template match="/">
        <svg height="{$chartHeight + 120}">
            <g transform="translate(200, {$chartHeight + 50})">
                <xsl:for-each select="1 to xs:integer($maxCount idiv 5)">
                    <xsl:variable name="xPos" as="xs:integer" select=". * $xScale*5"/>
                    <line x1="{$xPos}" y1="0" x2="{. * $xScale*5}"
                        y2="-{$chartHeight + ($interbarSpacing * $yScale)}" stroke="lightgray"/>
                    <text x="{$xPos}" y="20" text-anchor="middle">
                        <xsl:value-of select=".*5"/>
                    </text>
                </xsl:for-each>
                
<!-- Y position is determined by verbs -->
<!-- I am trying to put them in order of loudness of speaking acts (and addressibility?) -->
<!-- Then, according to addressibility(?), fill the bars with different colors  -->
<!-- horizontal ruling lines and verbs-->
                <xsl:for-each select="'shout', 'order', 'answer', 'ask'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:integer+" select="(13, 12, 11, 10)[$position]"/>
                    <rect x="0" y="-{$yPos}" width="{count(ex[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="red"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>
                
                
                <xsl:for-each select="'talk', 'continue'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:integer+" select="(9, 8)[$position]"/>
                    <rect x="0" y="-{$yPos}" width="{count(ex[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="red" fill-opacity="0.5"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>


                <xsl:for-each select="'grumble', 'murmur', 'whisper'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:integer+" select="(7, 6, 5)[$position]"/>
                    <rect x="0" y="-{$yPos}" width="{count(ex[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="purple" fill-opacity="0.5"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>             


                <xsl:for-each select="'Talk to himself', 'murmur to himself', 'whisper to himself'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:integer+" select="(4, 3, 2)[$position]"/>
                    <rect x="0" y="-{$yPos}" width="{count(ex[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="blue" fill-opacity="0.5"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>    

                <xsl:for-each select="'think'">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:variable name="yPos" as="xs:integer+" select="(1)[$position]"/>
                    <rect x="0" y="-{$yPos}" width="{count(ex[@trans eq current()]) * $xScale}"
                        height="{$barHeight * $yScale}" fill="blue"/>
                    <text x="-10" y="-{$yPos}" dy="{($barHeight div 2) * $yScale}" text-anchor="end"
                        alignment-baseline="middle">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>


            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>