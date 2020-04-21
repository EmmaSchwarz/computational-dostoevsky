<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>

    <!-- Stylesheet variables -->
    <xsl:variable name="keywords" as="xs:string+" select="//@to => distinct-values() => sort()"/>
    <xsl:variable name="speakers" as="xs:string+" select="//@whose => distinct-values() => sort()"/>
    <xsl:variable name="refs" as="element(ref)+" select="//ref"/>
    <xsl:variable name="nameLookup" as="map(*)"
        select="
        map{
        'petru' : 'Petrushka',
        'doub' : 'Double',
        'nar' : 'Narrator',
        'gol' : 'Goliadkin',
        'enemy' : 'Enemy',
        'kre' : 'Krestian Ivanovich'}
        "/>
    <!-- end of stylesheet variables -->
    
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
                <table>
                    <tr>
                        <th>&#xa0;</th>
                        <xsl:for-each select="$speakers">
                            <th>
                                <xsl:value-of select="$nameLookup(.)"/>
                            </th>
                        </xsl:for-each>
                    </tr>
                    <xsl:for-each select="$keywords">
                        <xsl:variable name="current_keyword" as="xs:string" select="current()"/>
                        <tr>
                            <td>
                                <xsl:value-of select="."/>
                            </td>
                            <xsl:for-each select="$speakers">
                                <td>
                                    <xsl:value-of
                                        select="$refs[@whose eq current() and @to eq $current_keyword] => count()"
                                    />
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
