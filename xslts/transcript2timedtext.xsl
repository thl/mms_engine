<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tts="http://www.w3.org/2006/04/ttaf1#styling"
    xmlns="http://www.w3.org/2006/10/ttaf1"
	version="1.0">
       
    <xsl:output method="xml" encoding="UTF-8" indent="yes" media-type="text/xml"/>
    
    <xsl:param name="form" select="'bo'"/>
    <xsl:param name="transl" select="''"/>
    
    <xsl:template match="/">
        <tt>
            <head>
	          <link href="/stylesheets/language_support.css" media="screen" rel="stylesheet" type="text/css" />
            </head>
            <body>
                <div xml:lang="en">
                    <xsl:apply-templates select="TITLE/TEXT/S"/>
                </div>
            </body>
        </tt>    
    </xsl:template>

    <xsl:template match="S">
        <xsl:if test="$form">
            <p begin="{format-number(AUDIO/@start, '#.00')}s" end="{format-number(AUDIO/@end, '#.00')}s">&lt;p align="center" class="bo"&gt;<xsl:value-of select="FORM[@xml:lang=$form]"/>&lt;/p&gt;</p>
        </xsl:if>
        <xsl:if test="$transl">            
            <p begin="{format-number(AUDIO/@start, '#.00')}s" end="{format-number(AUDIO/@end, '#.00')}s">&lt;font face="Times New Roman" size="12"&gt;<xsl:value-of select="TRANSL[@xml:lang=$transl]"/>&lt;/font&gt;</p>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
