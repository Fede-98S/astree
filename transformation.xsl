<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="1.0">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    
    <!-- Whitespace preserved to prevent text concatenation around inline elements -->

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:TEI">
       
    <html>
        <head>
            <meta charset="UTF-8"/>
            <title>
                <xsl:value-of select="//tei:titleStmt/tei:title"/>
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
            <button onclick="showDiv('edition')">Référence</button>
            <button onclick="showDiv('pre')">Préliminaire</button>
            <button onclick="showDiv('fonctionnelle')">Fonctionnelle</button>
            </div>
            
            <div id="edition" class="edition" style="display: block;">             
                <xsl:apply-templates select="tei:text/tei:body/node()"/>
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
       
    <xsl:template match="tei:p">
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
    
    <xsl:template match="tei:persName">
        <a href="#" class="personnage">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:div[@subtype='stance']">
        <div class="stance">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@subtype='madrigal']">
        <div class="madrigal">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:div[@subtype='sonnet']">
        <div class="stance">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head">
    <h3>
        <xsl:apply-templates/>
    </h3>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <div type="strophe">
            <xsl:apply-templates/>
        </div><br/>
    </xsl:template>
 
    <xsl:template match="tei:l">
        <span>
            <xsl:apply-templates/>
        </span><br/>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <sup><a href="#" class="note">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:apply-templates/>η
        </a></sup>
    </xsl:template>

    <xsl:template match="tei:graphic">
        <img src="{@url}" class="{@rend}" alt="{@rend}"/>
    </xsl:template>
</xsl:stylesheet>
