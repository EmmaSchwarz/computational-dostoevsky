<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

 
    <xsl:variable name="xScale" as="xs:integer" select="40"/>
    <xsl:variable name="yScale" as="xs:integer" select="40"/>

    <xsl:template match="/">
        <svg width="3000" height="2000">
            <g transform="translate(100, 400)">
                <xsl:for-each select="//div[@class eq 'chapter']">
                    
                    <!-- save chapter to look inside it later -->
                    <xsl:variable name="current_chapter" as="element(div)" select="."/>
                    <!-- X position is determined by chapter number -->
                    <xsl:variable name="xPos" as="xs:integer" select="position()"/>
                    
                    <!--line-->
                    <line x1="10" x2="10" y1="0" y2="-320" stroke="black" stroke-width="1"/>
                    <line x1="10" x2="{count(//div[@class eq 'chapter'])*$xScale}" y1="0" y2="0" stroke="black"
                        stroke-width="1"/>
                    <line x1="{$xPos* $xScale}" x2="{$xPos* $xScale}" y1="0"
                        y2="-320" stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>                 
 <!-- Issue 1 -->
 <!--Try to bring chapters(//div/@id) in x axis-->
                    <text x="{$xPos* $xScale}" y="10" text-anchor="middle">
                        <xsl:apply-templates select="//div/@id"/>
                    </text>
                   

                    <!-- Y position is determined by character or voice -->
                    <xsl:for-each select="'petru', 'doub'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(6, 5)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@speaker eq current()])"/>
                        
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                            fill-opacity="0.2" stroke="black" fill="red"/>

                        <!-- lines connecting the center points  -->                
                        <line x1="10" x2="{$xPos * $xScale + 20}" y1="-{$yPos * $yScale}"
                            y2="-{$yPos * $yScale}" stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>
<!-- Issue 2 -->
<!--the speaker names in y axis. I tried to figure out how to bring the full names... -->                        
                        <text x="-20" y="-{$yPos * $yScale}" text-anchor="end">
                            <xsl:value-of select="translate(., 'petru', 'Petrushka')"/>
                            <xsl:value-of select="translate(., 'doub', 'Double')"/>
                        </text>
                    </xsl:for-each>


                    <xsl:for-each select="'timid', 'confident', 'mocking'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(4, 3, 2)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@voice eq current()])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                            fill-opacity="0.5" stroke="black" fill="blue"/>                       
                        <!-- lines connecting the center points  -->                
                        <line x1="10" x2="{$xPos * $xScale + 20}" y1="-{$yPos * $yScale}"
                            y2="-{$yPos * $yScale}" stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>
                    </xsl:for-each>
   
                    <xsl:variable name="yPos" as="xs:integer" select="1"/>
                    <!-- process Narrator -->
                    <xsl:variable name="speech-count" as="xs:integer"
                        select="count($current_chapter/descendant::speech[@speaker eq 'nar'])"/>
                    <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                        fill-opacity="0.5" stroke="black" fill="red"/>                 
                    <!-- lines connecting the center points  -->                
                    <line x1="10" x2="{$xPos * $xScale + 20}" y1="-{$yPos * $yScale}"
                        y2="-{$yPos * $yScale}" stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
