<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fun="http://www11.in.tum.de/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- XSLT transformator Output -->
    <xsl:output method="html" encoding="UTF-8"/>
    
    <!-- Variables for the table -->
    <xsl:variable name="xTable" select="number(100)"/>
    <xsl:variable name="yTable" select="number(10)"/>
    <xsl:variable name="widthTable" select="number(1000)"/>
    <xsl:variable name="heightTable" select="number(200)"/>
    <xsl:variable name="heightRectTable" select="number(140)"/>
    <xsl:variable name="borderradiusTable" select="number(50)"/>
    <xsl:variable name="xRoundTable" select="number(600)"/>
    <xsl:variable name="yRoundTable" select="number(108)"/>
    <xsl:variable name="radiusOuterTable" select="number(500)"/>
    <xsl:variable name="radiusInnerTable" select="number(450)"/>
    <xsl:variable name="widthInnerTable" select="number(896)"/>
    <xsl:variable name="heightInnerRectTable" select="number(180)"/>
    <xsl:variable name="xInnerRectTable" select="number(152)"/>
    <xsl:variable name="yInnerRectTable" select="number(40)"/>
    
    <!-- Variables for logo -->
    <xsl:variable name="xLogo" select="number(450)"/>
    <xsl:variable name="yLogo" select="number(50)"/>
    
    <!-- TODO: Kartenplatz, Avatar, Textzug Variablen -->
    
    <!-- XSL Basic Template Start Point -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Blackjack Casino</title>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
            </head>
            <body>
                <xsl:apply-templates/>
                
            </body>
        </html>
    </xsl:template>
    
    
    <!-- XSL Basic Template Start Point -->
    <xsl:template match="blackjack">
        <!-- Variables -->
        <xsl:variable name="turnOfPlayerOne" select="turnOfPlayerOne"/>
        <xsl:variable name="gameOver" select="gameOver"/>
        
        <!-- Game board -->
        <svg xmlns="http://www.w3.org/2000/svg" width="1250" height="800">
            <clipPath id="rec">
                <rect x="{$xTable}%" y="{$yTable}%" width="{$widthTable}%" height="{$heightRectTable}%"/>
            </clipPath>
            <rect x="{$xTable + 2}%" y="{$yTable}%" width="{$widthTable - 4}%" height="{$heightTable}%" fill="black" stroke="black" rx="{$borderradiusTable}%" clip-path="url(#rec)" />
            <clipPath id="bot">
                <path d="M 0 150 h 1100 v 600 h -700 z"/>
            </clipPath>
            <circle cx="{$xRoundTable}%" cy="{$yRoundTable}%" r="{$radiusOuterTable}%" fill="black" clip-path="url(#bot)" />    
            <rect x="{$xInnerRectTable}%" y="{$yInnerRectTable}%" width="{$widthInnerTable}%" height="{$heightInnerRectTable}%" fill="darkgreen" stroke="white" stroke-width="5" rx="{$borderradiusTable}%" clip-path="url(#rec)" />
            <circle cx="{$xRoundTable}%" cy="{$yRoundTable}%" r="{$radiusInnerTable}%" fill="darkgreen" stroke="white" stroke-width="5" clip-path="url(#bot)" />
            <!-- ToDo: this image has to be referenced from our own server -->
            <image id="BJ-logo"
                xlink:href="http://www.dafont.com/forum/attach/orig/1/2/127066.png"
                x="{$xLogo}%" y="{$yLogo}%" height="100" width="300">
            </image>
            
            <defs>
                <rect id="kartenplatz" height="70" width="50" rx="6"/>
            </defs>
            
            <use x="575" y="460" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="475" y="750" transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="220" y="925" transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="510" y="150" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="325" y="-115" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <defs>
                <path id="insurance_text_path" d="M353,148 a90,90 0 0,0 494,0"/>
            </defs>
            <path d="M340,148 a90,90 0 0,0 520,0" fill="none" stroke="white" stroke-width="4"/>
            <path d="M390,148 a90,90 0 0,0 420,0" fill="none" stroke="white" stroke-width="4"/>
            <path d="M340,148 a10,10 0 0,1 50,0" fill="none" stroke="white" stroke-width="4"/>
            <path d="M810,148 a10,10 0 0,1 50,0" fill="none" stroke="white" stroke-width="4"/>
            <text font-family="Verdana" font-size="36" fill="white" text-anchor="middle" >
                <textPath xlink:href="#insurance_text_path" startOffset="50%" >
                    PAYS 2 TO 1 | INSURANCE | PAYS 2 TO 1
                </textPath>
            </text>
            
            <text x="600" y="200" font-family="Verdana" font-size="50" fill="white" text-anchor="middle" font-weight="bold">
                BLACK JACK
            </text>
            
            <use x="80" y="-280" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="83" y="-283" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="86" y="-286" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="89" y="-289" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <defs>
                <rect id="button" width="200" height="50"></rect>
            </defs>
            <style type="">
                .active_button{
                fill: white;
                stroke: black;
                }
                
                .active_button:hover{ 
                opacity: 0.9;
                }
                
                .disactive_button{
                fill: white;
                stroke: grey;
                }
            </style>
            
            <g class="disactive_button" style="display: none;">
                <use xlink:href="#button" x="275" y="750"></use>
                <text x="375" y="775" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Insurance</text>
            </g>
            
            <g class="active_button" style="display: none;">
                <use xlink:href="#button" x="500" y="750"></use>
                <text x="600" y="775" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Hit</text>
            </g>
            
            <g class="disactive_button" style="display: none;">
                <use xlink:href="#button" x="725" y="750"></use>
                <text x="825" y="775" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Stand</text>
            </g>
            
            <a xlink:href="/blackjack/newGame" xlink:title="start new game">
                <g class="active_button">
                    <use xlink:href="#button" x="500" y="250"></use>
                    <text x="600" y="275" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Start new Game</text>
                </g>
            </a>
            
            <defs>
                <g id="avatar">
                    <ellipse cx="25" cy="30" rx="25" ry="30" fill="none" stroke="black" stroke-width="6"></ellipse>
                    <path d="M-30,120 c0,-75 110,-75 110,0" fill="none" stroke="black" stroke-width="6"/>
                </g>
            </defs>
            <use xlink:href="#avatar" x="575" y="625"></use>
            <use xlink:href="#avatar" x="500" y="320" transform="rotate(30 0 0)"></use>
            <use xlink:href="#avatar" x="330" y="50" transform="rotate(60 0 0)"></use>
            <use xlink:href="#avatar" x="470" y="920" transform="rotate(-30 0 0)"></use>
            <use xlink:href="#avatar" x="220" y="1100" transform="rotate(-60 0 0)"></use>
        </svg>
    </xsl:template>
    
</xsl:stylesheet>