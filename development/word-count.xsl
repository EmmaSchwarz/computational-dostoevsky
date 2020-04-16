<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Word count                                                       -->
    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $speeches as element(speech)+ : all non-nested speeches          -->
    <!-- $speech_text as xs:string : concatenation of all speech text,    -->
    <!--   with punctuation stripped, lower-cased, whitespace-normalized  -->
    <!-- $words as xs:string+ : all word tokens in speeches               -->
    <!-- ================================================================ -->
    <xsl:variable name="speeches" as="element(speech)+" select="//speech[@speaker='gol'][not(ancestor::speech)]"/>
    <xsl:variable name="speech_text" as="xs:string"
        select="
            string-join($speeches//text(), ' ') !
            replace(., '\p{P}+', '') !
            normalize-space() !
            lower-case(.)
            "/>
    <xsl:variable name="words" as="xs:string+" select="tokenize($speech_text, ' ')"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Word count</title>
            </head>
            <body>
                <h1>Word count</h1>
                <p>Count of words in first half of <cite>The double</cite></p>
                <ul>
                    <xsl:for-each-group select="$words" group-by=".">
                        <xsl:sort select="count(current-group())" order="descending"/>
                        <xsl:sort select="current-grouping-key()"/>
                        <li>
                            <xsl:value-of
                                select="
                                    current-grouping-key() ||
                                    ': ' ||
                                    count(current-group())"
                            />
                        </li>
                    </xsl:for-each-group>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
