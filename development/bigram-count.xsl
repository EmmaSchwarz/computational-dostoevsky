<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <!-- ================================================================ -->
    <!-- Word count                                                       -->
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Keys                                                             -->
    <!--                                                                  -->
    <!-- wordByPosition : sequential words by position                    -->
    <!-- ================================================================ -->
    <xsl:key name="wordByPosition" match="word" use="count(preceding-sibling::word) + 1"/>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $speeches as element(speech)+ : all non-nested speeches          -->
    <!-- $speech_text as xs:string : concatenation of all speech text,    -->
    <!--   with punctuation stripped, lower-cased, whitespace-normalized  -->
    <!-- $words_as_strings as xs:string+ : all word tokens in speeches    -->
    <!-- $words as document-node(element(words)) : words as elements      -->
    <!--   structure as document to use key                               -->
    <!-- $bigrams as xs:string+ : bigrams                                 -->
    <!--   not necessarily bigrams because speeches are concatenated      -->
    <!-- ================================================================ -->
    <xsl:variable name="speeches" as="element(speech)+" select="//speech[@speaker='nar'][not(ancestor::speech)]"/>
    <xsl:variable name="speech_text" as="xs:string"
        select="
            string-join($speeches//text(), ' ') !
            replace(., '\p{P}+', '') !
            normalize-space() !
            lower-case(.)
            "/>
    <xsl:variable name="words_as_strings" as="xs:string+" select="tokenize($speech_text, ' ')"/>
    <xsl:variable name="words" as="document-node(element(words))">
        <xsl:document>
            <words xmlns="">
                <xsl:for-each select="$words_as_strings">
                    <word>
                        <xsl:sequence select="."/>
                    </word>
                </xsl:for-each>
            </words>
        </xsl:document>
    </xsl:variable>
    <xsl:variable name="bigrams" as="xs:string+">
        <xsl:for-each select="1 to count($words//word)">
            <xsl:value-of
                select="
                    key('wordByPosition', ., $words) ||
                    '_' ||
                    key('wordByPosition', number(.) + 1, $words)
                    "
            />
        </xsl:for-each>
    </xsl:variable>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Bigram count</title>
            </head>
            <body>
                <h1>Bigram count</h1>
                <p>Count of bigrams in first half of <cite>The double</cite></p>
                <ul>
                    <xsl:for-each-group select="$bigrams" group-by=".">
                        <xsl:sort select="count(current-group())" order="descending"/>
                        <xsl:sort select="current-grouping-key()"/>
                        <li>
                            <xsl:value-of
                                select="
                                    current-grouping-key() ! translate(., '_', ' ') ||
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
