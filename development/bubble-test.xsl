<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:kiun="http://kiun.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $maxLength as xs:integer : length of X axis                      -->
    <!-- $xScale as xs:integer : scale of x axis                          -->
    <!-- $yScale as xs:integer : scale of y axis                          -->    
    <!-- $cScale as xs:integer : scale of area of bubbles                 -->
    <!-- $nameLookup as map(*) : retrieve full char name from abbrev      -->
    <!-- ================================================================ -->
    <xsl:variable name="maxLength" as="xs:integer"
        select="count(//chapter) * $xScale + 40"/>
    <xsl:variable name="xScale" as="xs:integer" select="40"/>
    <xsl:variable name="yScale" as="xs:integer" select="40"/>
    <xsl:variable name="cScale" as="xs:integer" select="20"/>
    <xsl:variable name="nameLookup" as="map(*)"
        select="
        map{
        'petru' : 'Petrushka',
        'doub' : 'Double',
        'nar' : 'Narrator',
        'timid' : 'Goliadkin A',
        'confident' : 'Goliadkin B'
        }
        "/>
    <!-- ================================================================ -->
    
    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <!-- kiun:radiusFromSpeechCount                                       -->
    <!--                                                                  -->
    <!-- Parameter                                                        -->
    <!--   $speechCount as xs:integer: count of speeches (area of circle) -->
    <!--                                                                  -->
    <!-- Return                                                           -->
    <!--   xs:double: scale area and return radius                        -->
    <!-- ================================================================ -->
    <xsl:function name="kiun:radiusFromSpeechCount" as="xs:double">
        <xsl:param name="speechCount" as="xs:integer"/>
        <xsl:sequence
            select="
                ($speechCount * $cScale div math:pi())
                => math:sqrt()
                "
        />
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <svg width="3000" height="2000">
            <g transform="translate(100, 400)">

                <!-- horizontal ruling lines and labels on Y axis -->
                <xsl:for-each select="'nar', 'confident', 'timid', 'doub', 'petru'">
                    <!-- horizontal ruling lines  -->
                    <line x1="10" x2="{$maxLength}" y1="-{position() * $yScale}"
                        y2="-{position() * $yScale}" stroke="lightgray" stroke-width="1"
                        stroke-dasharray="2 2"/>
                    <!-- speaker name labels on Y axis -->
                    <text x="-10" y="-{position() * $yScale}" text-anchor="end">
                        <xsl:value-of select="$nameLookup(.)"/>
                    </text>
                </xsl:for-each>

                <!-- axes -->
                <line x1="10" x2="10" y1="0" y2="-250" stroke="black" stroke-width="1"/>
                <line x1="10" x2="{$maxLength}" y1="0" y2="0" stroke="black" stroke-width="1"/>

                <!-- process each chapter -->
                <xsl:for-each select="//chapter">

                    <!-- save chapter to look inside it later -->
                    <xsl:variable name="current_chapter" as="element(chapter)" select="."/>
                    <!-- X position is determined by chapter number -->
                    <xsl:variable name="xPos" as="xs:integer" select="position()"/>

                    <!-- vertical ruling lines -->
                    <line x1="{$xPos* $xScale}" x2="{$xPos* $xScale}" y1="0" y2="-250"
                        stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>
                    <!-- Issue 1 -->
                    <!--Try to bring chapters(//chapter/@id) in x axis-->
                    <text x="{$xPos* $xScale}" y="15" text-anchor="middle">
                        <xsl:apply-templates select="substring(@id, 3)"/>
                    </text>


                    <!-- Y position is determined by character or voice -->

                    <!-- top two characters -->
                    <xsl:for-each select="'petru', 'doub'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(5, 4)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@speaker eq current()])"/>

                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                            r="{kiun:radiusFromSpeechCount($speech-count)}" fill-opacity="0.2"
                            stroke="black" fill="red"/>
                        <xsl:message
                            select="string-join(($current_chapter/@id, current(), $speech-count), ' : ')"
                        />
                    </xsl:for-each>

                    <!-- three voices -->
                    <xsl:for-each select="'timid', 'confident'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(3, 2)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@voice eq current()])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                            r="{kiun:radiusFromSpeechCount($speech-count)}" fill-opacity="0.5"
                            stroke="black" fill="blue"/>
                        <xsl:message
                            select="string-join(($current_chapter/@id, current(), $speech-count), ' : ')"
                        />
                    </xsl:for-each>

                    <!-- narrator (last character) -->
                    <xsl:variable name="yPos" as="xs:integer" select="1"/>
                    <!-- process Narrator -->
                    <xsl:variable name="speech-count" as="xs:integer"
                        select="count($current_chapter/descendant::speech[@speaker eq 'nar'])"/>
                    <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                        r="{kiun:radiusFromSpeechCount($speech-count)}" fill-opacity="0.5"
                        stroke="black" fill="red"/>
                    <xsl:message
                        select="string-join(($current_chapter/@id, 'nar', $speech-count), ' : ')"/>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
