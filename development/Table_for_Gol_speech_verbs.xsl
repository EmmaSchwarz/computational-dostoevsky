<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        
        <html>
            <head>
                <title>Goliadkin's Speech Verbs</title>
                <style>
                    table { border-collapse: collapse; }
                    table, th, td { border: 1px solid black; }
                </style>
            </head>
            <body>
                <h1>Goliadkin's Speech Verbs</h1>
                <table>
                    <tr>
                        <th> </th>
                        <th>verbs</th>
                        <th>counts</th>
                    </tr>
                    <xsl:apply-templates select="//ex[@trans]"/>
                </table>

            </body>
        </html>
    </xsl:template>
    <xsl:for-each select="ex">
        
        <tr>
            <td>
                <xsl:value-of select="distinct-values(@trans)"/>
            </td>
            <td>
                <xsl:value-of select="count(.)"/>
            </td>
        </tr>
    </xsl:for-each>

</xsl:stylesheet>
