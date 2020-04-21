<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs math" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- Stylesheet variables -->
    <xsl:variable name="keywords" as="xs:string+"
        select="//@to[not(. eq 'сиамские близнецы')] => distinct-values() => sort()"/>
    <xsl:variable name="speakers" as="xs:string+"
        select="//@whose[not(. eq 'enemy')] => distinct-values() => sort()"/>
    <xsl:variable name="chapters" as="element(chapter)+" select="//chapter"/>
    <xsl:variable name="refs" as="element(ref)+" select="//ref"/>
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
    'gol' : 'magenta',
    'doub' : 'blue',
    'nar' : 'red',
    'kre' : 'green',
    'petru' : 'orange'
    }"/>
    <xsl:variable name="yScale" as="xs:integer" select="20"/>
    <!-- end of stylesheet variables -->

    <xsl:template match="/">
        <svg height="1500" width="1500">
            <g transform="translate(10, 600)">
                <!-- loop over keywords, then speakers, then chapters -->
                <xsl:for-each select="$keywords">
                    <xsl:variable name="graphXpos" as="xs:integer" select="(position() mod 3) * 350"/>
                    <xsl:variable name="graphYpos" as="xs:integer"
                        select="(position() mod 2) * -300"/>
                    <xsl:variable name="currentKeyword" as="xs:string" select="."/>
                    <g transform="translate({$graphXpos}, {$graphYpos})">
                        <!-- graph for individual keyword-->
                        <xsl:for-each select="$speakers">
                            <xsl:variable name="currentSpeaker" as="xs:string" select="."/>
                            <!-- draw a line, within the current graph, for each speaker -->
                            <xsl:variable name="currentPoints" as="xs:string+">
                                <xsl:for-each select="$chapters">
                                    <!-- for current keyword and speaker, loop over chapters -->
                                    <xsl:sequence
                                        select="
                                            position() * 25 ||
                                            ',' ||
                                            count(descendant::ref[@to eq $currentKeyword and @whose eq $currentSpeaker]) * -1 * $yScale
                                            "
                                    />
                                </xsl:for-each>
                            </xsl:variable>
                            <polyline points="{$currentPoints}"
                                stroke="{$colorsBySpeaker($currentSpeaker)}" stroke-width="2"
                                fill="none"/>
                        </xsl:for-each>
                        <!-- baseline -->
                        <line stroke="black" stroke-width="2" x1="0" y1="0"
                            x2="{count($chapters) * 25}" y2="0"/>
                        <!-- label each small multiple by keyword -->
                        <text x="10" y="20">
                            <xsl:value-of select="$currentKeyword"/>
                        </text>
                    </g>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
