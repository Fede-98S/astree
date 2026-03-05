<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs math tei"
    version="3.0">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    
    <xsl:strip-space elements="*"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="tei:TEI">
        
    <html>
        <head>
            <meta charset="UTF-8"/>
            <title>
                <xsl:value-of select="//titleStmt/title"/>
            </title>
            <link rel="stylesheet" href="style.css"/>
        </head>
        <body>
            <header>
                <h1>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </h1>
            </header>
            <div class="button">
            <button onclick="showDiv('edition')">Édition</button>
            <button onclick="showDiv('editorial')">Fonctionelle</button>
                <!-- <button onclick="showDiv('edition')">Edition</button> -->
                <!-- <button onclick="showDiv('biblio')">Bibliographie</button> -->
            </div>
            
            <div id="edition" class="edition" style="display: block;">             
                <xsl:apply-templates select="tei:text/body/node()"/>
            </div>
            <div id="apparat" class="apparat" style="display: block;">             

            </div>
            <!-- <div id="editorial" class="editorial_info" style="display: none;">
                <xsl:apply-templates select="tei:teiHeader/tei:encodingDesc/tei:editorialDecl/node()"/>
            </div>
            <div id="edition" class="edition" style="display: none;">
                <button class="collapsible">Épître</button>
                <div class="content">
                    <xsl:apply-templates select="//tei:front/tei:div[@type = 'epistle']/node()"/>
                </div>
                <button class="collapsible">Personnages</button>
                <div class="content">
                    <xsl:apply-templates select="//tei:front/castList[@ana='prologue']|//tei:front/set[@ana='prologue']" mode="personnages"/>   
                </div>
                <button class="collapsible">Prologue: <i>La Conqueste de Brunswick</i></button>
                <div class="content">
                    <br/><span class="page_num">p. <xsl:value-of select="//tei:div[@type='prologue']/tei:pb/./@n"/></span><br/>
                    <h2><xsl:value-of select="//tei:body/tei:div/tei:head"/></h2>
                    <xsl:apply-templates select="//tei:body/tei:div/tei:div[@type = 'scene']/node()"/>     
                </div>
                <button class="collapsible">Interprétation</button>
                <div class="content">
                    <xsl:apply-templates select="//tei:interp" mode="interp"/>   
                </div>
            </div>
            <div id="biblio" class="biblio" style="display: none;">
                <xsl:apply-templates select="//tei:listBibl"/>
            </div>-->
            
            
            <script src="script.js"></script>
        </body>
    </html>
    
    </xsl:template>
       
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
   
    <xsl:template match="//tei:pb">
        <br/><span class="page_num">p. <xsl:value-of select="./@n"/>
        </span><br/>
    </xsl:template>
        
    <xsl:template match="tei:head[@rend='alignCenter']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/><xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:app">
        <span class="variant">

                <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lem">
            <span class="var21">
                <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <span class="varp" id="varp">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:term">
        <a href="#" class="glossaire">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:rs">
        <a href="#" class="repertoire">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
 
</xsl:stylesheet>
