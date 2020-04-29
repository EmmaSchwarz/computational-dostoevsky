<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>The Double Text</title>
            </head>
            <body>
                <h1>
                    <xsl:apply-templates select="//title"/>
                </h1>
                <h2>
                    <xsl:apply-templates select="//subhead"/>
                </h2>
                <xsl:apply-templates select="//chapter"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="chapter">
        <h3>
            <a id="{@id}"><xsl:apply-templates select="h2"/></a>
        </h3>
        <xsl:apply-templates select="p"/>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="speech[@voice = 'timid']">
        <span class="timid">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="speech[@voice = 'confident']">
        <span class="confident">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="speech[@voice = 'mocking']">
        <span class="mocking">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>
