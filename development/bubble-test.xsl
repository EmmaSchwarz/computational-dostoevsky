<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/2000/svg"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!--
        Petruska
        Double
            Timid
            Confident
            Mocking
        Narrator
    -->
    <xsl:variable name="xScale" as="xs:integer" select="40"/>
    <xsl:variable name="yScale" as="xs:integer" select="40"/>

    <xsl:template match="/">
        <svg width="2000" height="1000">
            <g transform="translate(10, 300)">
                <xsl:for-each select="//div[@class eq 'chapter']">
                    <!-- save chapter to look inside it later -->
                    <xsl:variable name="current_chapter" as="element(div)" select="."/>
                    <!-- X position is determined by chapter number -->
                    <xsl:variable name="xPos" as="xs:integer" select="position()"/>

                    <!-- Y position is determined by character or voice -->

                    <xsl:for-each select="'petru', 'doub'">
                        <xsl:variable name="position" select="position()"/>
                        <!-- Y position is 6 for Petrushka and 5 for Double -->
                        <xsl:variable name="yPos" as="xs:integer+" select="(6, 5)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@speaker eq current()])"/>
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                            fill-opacity="0" stroke="black"/>
                    </xsl:for-each>

                    <xsl:for-each select="'timid', 'confident', 'mocking'">
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="yPos" as="xs:integer+" select="(4, 3, 2)[$position]"/>
                        <xsl:variable name="speech-count" as="xs:integer"
                            select="count($current_chapter/descendant::speech[@voice eq current()])"/>
                        <!-- process G voices -->
                        <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                            fill-opacity="0" stroke="black"/>
                    </xsl:for-each>

                    <!-- Y position is 1 for narrator -->
                    <xsl:variable name="yPos" as="xs:integer" select="1"/>
                    <!-- process Narrator -->
                    <xsl:variable name="speech-count" as="xs:integer"
                        select="count($current_chapter/descendant::speech[@speaker eq 'nar'])"/>
                    <circle cx="{$xPos * $xScale}" cy="-{$yPos * $yScale}" r="{$speech-count}"
                        fill-opacity="0" stroke="black"/>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
