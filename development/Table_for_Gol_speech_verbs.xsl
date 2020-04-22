<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="xs" version="3.0">
        <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    
    <xsl:variable name="verbs" as="xs:string+" select="//@trans => distinct-values() => sort()"/>
    
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
                        <th>VERBS</th>
                        <th>COUNTS</th>
                    </tr>
                    <xsl:for-each select="$verbs">
                        <xsl:variable name="current_verbs" as="xs:string" select="current()"/>                        
                        <tr>
                            <td>
                                <xsl:value-of select="."/>
                            </td>

                            <td>
                                <xsl:value-of select="$current_verbs[@trans eq current()] => count()"/>
                            </td>
                        </tr>
                    </xsl:for-each>

                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>


<!-- <xsl:variable name="verbs" as="" select="//ex[@trans] then all the R verbs (values) appear  -->

<!-- distinct-values return strings, "disembodied", cut off from its tree. 
    So if you want to go back to the tree, but in the preceding syntax <for-each> defined sth else, you need to create $root 
to get back to the original tree. -->
<!-- xslt only works in current-context(). <for-each> sets the current-context and changes it (in this case, current-contest returns string). 
when you do <for-each> over strings (such as distinct-values, and you want to refer back to tress, we need $root-->
<!-- when processing nodes - <apply-templates> better, when process strings for-each inside template -->
<!-- <for-each> cannot be a direct child of stylesheet. BUt if embedded, it is all right -->
