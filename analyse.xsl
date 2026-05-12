<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math tei"
    version="1.0">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    
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
                <nav class="sidebar">
                    <h3>L'Astrée</h3>
                    <a href="index.html" class="nav-link">Accueil / Index</a>
                    <a href="glossaire.html" class="nav-link">Glossaire</a>
                    <a href="notes_2.html" class="nav-link">Notes</a>
                    <a href="personnages.html" class="nav-link">Personnages</a>
                    <a href="repertoire.html" class="nav-link">Répertoire</a>
                    
                    <h3 style="margin-top:2rem">Navigation</h3>
                    <a href="#" onclick="history.back()" class="nav-link">← Retour</a>
                </nav>
                <header>
                    <h1>
                        <xsl:value-of select="//tei:titleStmt/tei:title"/>
                    </h1>
                </header>
                
                <div id="glossaire">
                    <h2>Repertoire</h2>
                    <table border="1">
                        <tr bgcolor="#9acd32">
                            <th>Terme</th>
                            <th>Définition</th>
                            <th>Où</th>
                        </tr>
                        <xsl:for-each select="//tei:note">
                            <tr>
                                <td>   
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    
                                    <xsl:value-of select="tei:label"/>
                                </td>
                                <td>
                                    <xsl:apply-templates select="tei:*[not(self::tei:label)] | text()"/>
                                </td>
                                <td><xsl:value-of select="@n"/></td>
                            </tr>
                        </xsl:for-each>
                    </table>
                    
                </div>
                
                
                <script src="script.js"></script>
            </body>
        </html>
        
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
    
    <xsl:template match="tei:rs">
        <a href="#" class="repertoire">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <span><a href="#">            
            <xsl:attribute name="data-url">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a></span>
    </xsl:template>
    
    
    
    <xsl:template match="tei:hi">
        <i><xsl:apply-templates/></i>
    </xsl:template>
    <xsl:template match="tei:ref">
        <a href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
</xsl:stylesheet>
