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
                <h3>Оглавление</h3>
                <ul>
                    <xsl:apply-templates select="//h2" mode="toc"/>
                </ul>
                <xsl:apply-templates select="//chapter"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="h2" mode="toc">
        <li>
            <a href="#{ancestor::chapter/@id}" name="{ancestor::chapter/@id}_toc"
                id="{ancestor::chapter/@id}_toc">
                <xsl:apply-templates/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="chapter" mode="toc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="chapter">
        <h3>
            <a href="#{@id}_toc" name="{@id}" id="{@id}">
                <xsl:apply-templates select="h2"/>
            </a>
        </h3>
        <xsl:apply-templates select="p"/>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="speech[@voice = 'timid']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="speech[@voice = 'confident']">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="speech[@voice = 'mocking']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>
</xsl:stylesheet>
