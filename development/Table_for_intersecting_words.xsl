<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" 
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:variable name="keywords" as="xs:string+" select="//@to => distinct-values()"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Intersecting Words</title>
                <style>
                    table {
                        border-collapse: collapse;
                    }
                    table,
                    th,
                    td {
                        border: 1px solid black;
                    }</style>
            </head>
            <body>
                <h1>Intersecting Words</h1>
                <xsl:for-each select="//ref[@to = 'enemy']">
                    <p>
                        <xsl:value-of select="."/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="count(distinct-values(@whose))"/>
                    </p>
                </xsl:for-each>
                <table>
                    <tr>
                        <th> </th>
                        <th>враг</th>
                    </tr>
                    <xsl:apply-templates select="//ref[@to = 'enemy']"/>
                </table>
                <table>
                    <tr>
                        <th> </th>
                        <th>приличие</th>
                    </tr>
                    <xsl:apply-templates select="//ref[@to = 'decoum']"/>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:variable name="nameLookup" as="map(*)"
            select="
            map{
            'petru' : 'Petrushka',
            'doub' : 'Double',
            'nar' : 'Narrator',
            'gol' : 'Goliadkin',
            'kre' : 'Krestian Ivanovich'}
            "/>
        <tr>
            <td>
                <xsl:apply-templates select="distinct-values(//@whose)"/>
            </td>
            <td>
                <xsl:apply-templates select="count(@whose)"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="ref">
        <tr>
            <td>
                <xsl:apply-templates select="distinct-values(@whose)"/>
            </td>
            <td>
                <xsl:apply-templates select="count(@whose)"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
