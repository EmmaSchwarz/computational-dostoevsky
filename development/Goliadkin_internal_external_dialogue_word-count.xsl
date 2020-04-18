<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml" version="3.0">
    <xsl:output method="xml" indent="yes"/>



    <xsl:variable name="speeches"  select="//speech[speaker='gol']"/>
    <xsl:variable name="speech_text" as="xs:string"
        select="
        string-join($speeches//text(), ' ') !
        replace(., '\p{P}+', '') !
        normalize-space() !
        lower-case(.)
        "/>
    <xsl:variable name="words" as="xs:string+" select="tokenize($speech_text, ' ')"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Goliadkin Word Count</title>
            </head>
            <body>
                <h1>Word count</h1>
                <p>Word Count in Goliadkin speech</p>
                <xsl:apply-templates select="count($words)"/>              
            </body>
        </html>
    </xsl:template>



<!--
    <xsl:template match="/">
            <xsl:variable name="speeches">
                <xsl:apply-templates select="//speech[speaker='gol']"/>
            </xsl:variable>
        
 Count the number of words by counting the number of spaces 
            Count:<xsl:value-of select="string-length(speeches) - string-length(translate(speeches, ' ', ''))" />
        </xsl:template>
        
Return the normalised string with one space at the end 
    <xsl:template match="//speech[speaker='gol']">
            <xsl:value-of select="concat(normalize-space(.), ' ')" />
        </xsl:template>
-->        
    
</xsl:stylesheet>
