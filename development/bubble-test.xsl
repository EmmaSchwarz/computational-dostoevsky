<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:kiun="http://kiun.org"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <!-- set @indent to "no" to fix <tspan> spacing -->
    <xsl:output method="xml" indent="no"/>

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $maxLength as xs:integer : length of X axis                      -->
    <!-- $xScale as xs:integer : scale of x axis                          -->
    <!-- $yScale as xs:integer : scale of y axis                          -->
    <!-- $cScale as xs:integer : scale of area of bubbles                 -->
    <!-- $nameLookup as map(*) : retrieve full char name from abbrev      -->
    <!-- &#x0A; not working for svg                                       -->
    <!-- ================================================================ -->
    <xsl:variable name="maxLength" as="xs:integer" select="count(//chapter) * $xScale + 40"/>
    <xsl:variable name="xScale" as="xs:integer" select="50"/>
    <xsl:variable name="yScale" as="xs:integer" select="40"/>
    <xsl:variable name="cScale" as="xs:integer" select="20"/>
    <xsl:variable name="nameLookup" as="map(*)"
        select="
        map{
        'petru' : 'Petrushka',
        'doub' : 'Double',
        'nar' : 'Narrator',
        'timid' : 'Goliadkin for himself',
        'confident' : 'Goliadkin-confident&#x0a;for the other',
        'mocking' : 'Goliadkin-mocking&#x0a;for the other'
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
    <xsl:function name="kiun:radiusFromArea" as="xs:double">
        <xsl:param name="speechCount" as="xs:integer"/>
        <!-- area = radius^2 * pi -->
        <xsl:sequence select="
                math:sqrt($cScale * $speechCount div math:pi())"/>
    </xsl:function>

    <!-- ================================================================ -->
    <!-- kiun:twoLine                                                     -->
    <!--                                                                  -->
    <!-- Synopsis: identify two-line labels by newline character, split   -->
    <!--                                                                  -->
    <!-- Parameter                                                        -->
    <!--   $inName as xs:string: name of character, from markup           -->
    <!--                                                                  -->
    <!-- Return                                                           -->
    <!--   svg:text, with one or more <tspan> children                    -->
    <!-- ================================================================ -->
    <xsl:function name="kiun:twoLine" as="element(svg:text)">
        <xsl:param name="inName" as="xs:string"/>
        <xsl:param name="yPos" as="xs:double"/>
        <xsl:variable name="outName" as="xs:string" select="$nameLookup($inName)"/>
        <text x="-10" y="{$yPos}" text-anchor="end">
            <xsl:choose>
                <xsl:when test="contains($outName, '&#x0a;')">
                    <xsl:variable name="parts" as="xs:string+" select="tokenize($outName, '&#x0a;')"/>
                    <tspan x="-10" dy="-03">
                        <xsl:value-of select="$parts[1]"/>
                    </tspan>
                    <tspan x="-10" dy="18">
                        <xsl:value-of select="$parts[2]"/>
                    </tspan>
                </xsl:when>
                <xsl:otherwise>
                    <tspan x="-10">
                        <xsl:value-of select="$outName"/>
                    </tspan>
                </xsl:otherwise>
            </xsl:choose>
        </text>
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <svg width="1000" height="500">
            <g transform="translate(200, 400)">

                <!-- horizontal ruling lines and labels on Y axis -->
                <xsl:for-each select="'nar', 'mocking', 'confident', 'timid', 'doub', 'petru'">
                    <!-- horizontal ruling lines  -->
                    <line x1="10" x2="{$maxLength}" y1="-{position() * $yScale}"
                        y2="-{position() * $yScale}" stroke="lightgray" stroke-width="1"
                        stroke-dasharray="2 2"/>
                    <!-- speaker name labels on Y axis, split long names over two lines -->
                    <xsl:sequence select="kiun:twoLine(., -position() * $yScale)"/>
                </xsl:for-each>

                <!-- axes -->
                <line x1="10" x2="10" y1="0" y2="-280" stroke="black" stroke-width="1"/>
                <line x1="10" x2="{$maxLength}" y1="0" y2="0" stroke="black" stroke-width="1"/>


                <!-- what indicates axes -->
                <!-- sth wrong with chapters -->
                <text x="{$maxLength div 2}" y="50" text-anchor="middle" font-size="larger"
                    >CHAPTERS</text>
                <text x="10" y="-290" text-anchor="middle" font-size="larger">CHARACTERS in
                    DIALOGUES</text>

                <!-- process each chapter -->
                <xsl:for-each select="//chapter">

                    <!-- save chapter to look inside it later -->
                    <xsl:variable name="current_chapter" as="element(chapter)" select="."/>
                    <!-- X position is determined by chapter number -->
                    <xsl:variable name="xPos" as="xs:integer" select="position()"/>

                    <!-- vertical ruling lines -->
                    <line x1="{$xPos* $xScale}" x2="{$xPos* $xScale}" y1="0" y2="-280"
                        stroke="black" opacity="0.2" stroke-width="1" stroke-dasharray="2 2"/>
                    <!-- Issue 1 -->
                    <!--Try to bring chapters(//chapter/@id) in x axis-->
                    <text x="{$xPos* $xScale}" y="15" text-anchor="middle"
                        text-decoration="underline">
                        <a xlink:href="http://dostoevsky.obdurodon.org/text.xhtml#{@id}">
                            <xsl:apply-templates select="substring(@id, 3)"/>
                        </a>
                    </text>


                    <!-- Y position is determined by character or voice -->
                    <!-- top two characters, Petrushka and Double, are pink -->
                    <xsl:for-each select="'petru', 'doub'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(6, 5)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@speaker eq current()])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                            r="{kiun:radiusFromArea($speech-count)}" fill-opacity="0.2"
                            stroke="black" fill="red"/>
                        <xsl:message
                            select="string-join(($current_chapter/@id, current(), $speech-count), ' : ')"
                        />
                    </xsl:for-each>


                    <!-- three voices are blue -->
                    <xsl:for-each select="'timid', 'confident', 'mocking'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(4, 3, 2)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@voice eq current()])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                            r="{kiun:radiusFromArea($speech-count)}" fill-opacity="0.5"
                            stroke="black" fill="blue"/>
                        <xsl:message
                            select="string-join(($current_chapter/@id, current(), $speech-count), ' : ')"
                        />
                    </xsl:for-each>

                    <!-- narrator (last character) is red -->
                    <xsl:for-each select="'nar'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer" select="1[$position]"/>
                        <!-- process Narrator -->
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@speaker eq 'nar'])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}"
                            r="{kiun:radiusFromArea($speech-count)}" fill-opacity="0.5"
                            stroke="black" fill="red"/>
                        <xsl:message
                            select="string-join(($current_chapter/@id, 'nar', $speech-count), ' : ')"
                        />
                    </xsl:for-each>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
