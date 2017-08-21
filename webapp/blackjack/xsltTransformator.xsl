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

    <!-- Kartenplaetze -->
    <xsl:variable name="xKartenplatz3" select="number(575)"/>
    <xsl:variable name="yKartenplatz3" select="number(460)"/>
    <xsl:variable name="xKartenplatz2" select="number(475)"/>
    <xsl:variable name="yKartenplatz2" select="number(750)"/>
    <xsl:variable name="xKartenplatz1" select="number(220)"/>
    <xsl:variable name="yKartenplatz1" select="number(925)"/>
    <xsl:variable name="xKartenplatz4" select="number(510)"/>
    <xsl:variable name="yKartenplatz4" select="number(150)"/>
    <xsl:variable name="xKartenplatz5" select="number(325)"/>
    <xsl:variable name="yKartenplatz5" select="number(-115)"/>
    <xsl:variable name="xKartenplatzDealer" select="number(600)"/>
    <xsl:variable name="yKartenplatzDealer" select="number(60)"/>

    <!-- Ablagestapel -->
    <xsl:variable name="xAblagestapel" select="number(80)"/>
    <xsl:variable name="yAblagestapel" select="number(-280)"/>

    <!-- Variables for Text -->
    <xsl:variable name="xText" select="number(600)"/>
    <xsl:variable name="yText" select="number(200)"/>

    <!-- Variables for Avatars -->
    <xsl:variable name="xAvatar1" select="number(575)"/>
    <xsl:variable name="yAvatar1" select="number(625)"/>
    <xsl:variable name="xAvatar2" select="number(500)"/>
    <xsl:variable name="yAvatar2" select="number(320)"/>
    <xsl:variable name="xAvatar3" select="number(330)"/>
    <xsl:variable name="yAvatar3" select="number(50)"/>
    <xsl:variable name="xAvatar4" select="number(470)"/>
    <xsl:variable name="yAvatar4" select="number(920)"/>
    <xsl:variable name="xAvatar5" select="number(220)"/>
    <xsl:variable name="yAvatar5" select="number(1100)"/>
    
    <!-- Variables for Coins -->
    <xsl:variable name="xCoin1" select="number(1026)"/>
    <xsl:variable name="yCoin1" select="number(320)"/>
    <xsl:variable name="xCoin2" select="number(862)"/>
    <xsl:variable name="yCoin2" select="number(508)"/>
    <xsl:variable name="xCoin3" select="number(601)"/>
    <xsl:variable name="yCoin3" select="number(585)"/>
    <xsl:variable name="xCoin4" select="number(325)"/>
    <xsl:variable name="yCoin4" select="number(500)"/>
    <xsl:variable name="xCoin5" select="number(175)"/>
    <xsl:variable name="yCoin5" select="number(320)"/>

    <!-- Variables for Buttons -->
    <xsl:variable name="widthButton" select="number(200)"/>
    <xsl:variable name="heightButton" select="number(50)"/>
    <xsl:variable name="xButtonCenter" select="number(600)"/>
    <xsl:variable name="yButton" select="number(780)"/>
    <xsl:variable name="xButton" select="$xButtonCenter - 100"/>
    <xsl:variable name="yTextButton" select="$yButton + 30"/>

    <!-- XSL Basic Template Start Point -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Black Jack Casino</title>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>


    <!-- XSL Basic Template Start Point -->
    <xsl:template match="game">
        <!-- Variables -->
        <xsl:variable name="gameId" select="./@id"/>
        <xsl:variable name="player3" select="players/player[seat=3]"/>
        <xsl:variable name="player4" select="players/player[seat=4]"/>
        <xsl:variable name="player5" select="players/player[seat=5]"/>
        <xsl:variable name="player1" select="players/player[seat=1]"/>
        <xsl:variable name="player2" select="players/player[seat=2]"/>
        <xsl:variable name="playerActive" select="activePlayer/@id"/>
        

        <!-- Game board -->
        <svg xmlns="http://www.w3.org/2000/svg" width="1400" height="790">
            <clipPath id="rec">
                <rect x="{$xTable}" y="{$yTable}" width="{$widthTable}" height="{$heightRectTable}"/>
            </clipPath>
            <rect x="{$xTable + 2}" y="{$yTable}" width="{$widthTable - 4}" height="{$heightTable}" fill="black" stroke="black" rx="{$borderradiusTable}" clip-path="url(#rec)" />
            <clipPath id="bot">
                <path d="M 0 150 h 1100 v 600 h -700 z"/>
            </clipPath>
            <circle cx="{$xRoundTable}" cy="{$yRoundTable}" r="{$radiusOuterTable}" fill="black" clip-path="url(#bot)" />
            <rect x="{$xInnerRectTable}" y="{$yInnerRectTable}" width="{$widthInnerTable}" height="{$heightInnerRectTable}" fill="darkgreen" stroke="white" stroke-width="5" rx="{$borderradiusTable}" clip-path="url(#rec)" />
            <circle cx="{$xRoundTable}" cy="{$yRoundTable}" r="{$radiusInnerTable}" fill="darkgreen" stroke="white" stroke-width="5" clip-path="url(#bot)" />

           <!-- <image id="BJ-logo"
                xlink:href="/static/blackjack/img/blackjack.png"
                x="{$xLogo}" y="{$yLogo}" height="100" width="300">
            </image>-->

            <defs>
                <rect id="kartenplatz" height="70" width="50" rx="6"/>
            </defs>

            <use x="{$xKartenplatz3}" y="{$yKartenplatz3}" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz2}" y="{$yKartenplatz2}" transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz1}" y="{$yKartenplatz1}" transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz4}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz5}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatzDealer}" y="{$yKartenplatzDealer}" xlink:href="#kartenplatz" stroke="white" fill="none"/>
            
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

            <text x="{$xText}" y="{$yText}" font-family="Verdana" font-size="50" fill="white" text-anchor="middle" font-weight="bold">
                BLACK JACK
            </text>

            <use x="{$xAblagestapel}" y="{$yAblagestapel}" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="{$xAblagestapel + 3}" y="{$yAblagestapel - 3}" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="{$xAblagestapel + 6}" y="{$yAblagestapel - 6}" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>
            <use x="{$xAblagestapel + 9}" y="{$yAblagestapel - 9}" transform="rotate(90 0 0)" xlink:href="#kartenplatz" fill="white" stroke="grey" stroke-width="2"/>

            <defs>
                <g id="avatar">
                    <ellipse cx="25" cy="30" rx="25" ry="30" fill="none" stroke="black" stroke-width="6"></ellipse>
                    <path d="M-30,120 c0,-75 110,-75 110,0" fill="none" stroke="black" stroke-width="6"/>
                </g>

                <g id="avatar_active">
                    <ellipse cx="25" cy="30" rx="25" ry="30" fill="green" stroke="black" stroke-width="6"></ellipse>
                    <path d="M-30,120 c0,-75 110,-75 110,0" fill="green" stroke="black" stroke-width="6"/>
                </g>

                <g id="chip-coin">
                    <circle r="15" stroke="black" stroke-width="3" fill="gold" />
                </g>

                <text id="chip-value-2" font-size="11.5" fill="black">2</text>
                <text id="chip-value-5" font-size="11.5" fill="black">5</text>
                <text id="chip-value-10" font-size="11.5" fill="black">10</text>
                <text id="chip-value-20" font-size="11.5" fill="black">20</text>

                <g id="chip-2">
                    <use xlink:href="#chip-coin" />
                    <use xlink:href="#chip-value-2" x="-2" y="5" />
                </g>
                <g id="chip-5">
                    <use xlink:href="#chip-coin" />
                    <use xlink:href="#chip-value-5" x="-2" y="5" />
                </g>
                <g id="chip-10">
                    <use xlink:href="#chip-coin" />
                    <use xlink:href="#chip-value-10" x="-2" y="5" />
                </g>
                <g id="chip-20">
                    <use xlink:href="#chip-coin" />
                    <use xlink:href="#chip-value-20" x="-2" y="5" />
                </g>
                <g id="chipP1">
                  <use xlink:href="#chip-coin" x="{$xCoin1}" y="{$yCoin1}" />
                  <text x="{$xCoin1}" y="{$yCoin1}"  fill="black" text-anchor="middle" dominant-baseline="central"  >
                        <xsl:value-of select="$player1/bet"/>
                  </text>
                </g>
                <g id="chipP2">
                    <use xlink:href="#chip-coin" x="{$xCoin2}" y="{$yCoin2}" />
                    <text x="{$xCoin2}" y="{$yCoin2}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player2/bet"/>
                    </text>
                </g>
                <g id="chipP3">
                    <use xlink:href="#chip-coin" x="{$xCoin3}" y="{$yCoin3}" />
                    <text x="{$xCoin3}" y="{$yCoin3}" fill="black" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="$player3/bet"/>
                    </text>
                </g>
                <g id="chipP4">
                    <use xlink:href="#chip-coin" x="{$xCoin4}" y="{$yCoin4}" />
                    <text x="{$xCoin4}" y="{$yCoin4}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player4/bet"/>
                    </text>
                </g>
                <g id="chipP5">
                    <use xlink:href="#chip-coin" x="{$xCoin5}" y="{$yCoin5}" />
                    <text x="{$xCoin5}" y="{$yCoin5}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player5/bet"/>
                    </text>
                </g>
            </defs>
            
         
            
            <xsl:choose>
                <xsl:when test="$player1/bet>0">
                    <use  xlink:href="#chipP1" />
                     
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player2/bet>0">
                    <use  xlink:href="#chipP2" />
                    
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player3/bet>0">
                    <use  xlink:href="#chipP3" />
                    
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player4/bet>0">
                    <use  xlink:href="#chipP4" />
                    
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player5/bet>0">
                    <use  xlink:href="#chipP5" />
                    
                </xsl:when>
            </xsl:choose>
  
            <xsl:choose>
                <xsl:when test="activePlayer/@id = $player3/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                    <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="white" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif" >
                      <xsl:value-of select="$player3/name"/>
                    </text>
                    <text x="{$xAvatar1+25}" y="{$yAvatar1+135}" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                        <xsl:value-of select="concat('Balance: ',$player3/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$player3">
                            <use xlink:href="#avatar" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                            <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="black" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="$player3/name"/>
                            </text>
                            <text x="{$xAvatar1+25}" y="{$yAvatar1+135}" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="concat('Balance: ',$player3/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = $player4/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                    <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                      <xsl:value-of select="$player4/name"/>
                    </text>
                    <text x="{$xAvatar2+25}" y="{$yAvatar2+135}" transform="rotate(30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                        <xsl:value-of select="concat('Balance: ',$player4/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$player4">
                            <use xlink:href="#avatar" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                            <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="$player4/name"/>
                            </text>
                            <text x="{$xAvatar2+25}" y="{$yAvatar2+135}" transform="rotate(30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="concat('Balance: ',$player4/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = $player5/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                    <text x="{$xAvatar3+25}" y="{$yAvatar3+110}" transform="rotate(60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                      <xsl:value-of select="$player5/name"/>
                    </text>
                    <text x="{$xAvatar3+25}" y="{$yAvatar3+135}" transform="rotate(60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                        <xsl:value-of select="concat('Balance: ',$player5/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$player5">
                            <use xlink:href="#avatar" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                            <text x="{$xAvatar3+25}" y="{$yAvatar3+105}" transform="rotate(60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="$player5/name"/>
                            </text>
                            <text x="{$xAvatar3+27}" y="{$yAvatar3+128}" transform="rotate(60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="concat('Balance: ',$player5/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = $player2/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                    <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                      <xsl:value-of select="$player2/name"/>
                    </text>
                    <text x="{$xAvatar4+25}" y="{$yAvatar4+135}" transform="rotate(-30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                        <xsl:value-of select="concat('Balance: ',$player2/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$player2">
                            <use xlink:href="#avatar" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                            <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="$player2/name"/>
                            </text>
                            <text x="{$xAvatar4+25}" y="{$yAvatar4+135}" transform="rotate(-30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="concat('Balance: ',$player2/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = $player1/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                    <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                      <xsl:value-of select="$player1/name"/>
                    </text>
                    <text x="{$xAvatar5+25}" y="{$yAvatar5+135}" transform="rotate(-60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                        <xsl:value-of select="concat('Balance: ',$player1/balance)"/>
                    </text>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$player1">
                            <use xlink:href="#avatar" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                            <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="$player1/name"/>
                            </text>
                            <text x="{$xAvatar5+25}" y="{$yAvatar5+135}" transform="rotate(-60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central" font-family = "Arial, Helvetica, sans-serif">
                                <xsl:value-of select="concat('Balance: ',$player1/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            
            <defs>
                <g id="generic-blackjack-table">
                    <!-- blackjack-table -->
                    <image x="200" y="-200" width="1000" height="1000"
                        xlink:href="https://www.rightcasino.com/media/need-to-know/games/blackjack/blackjack_table.png" />
                    
                    <!-- blackjack-logo -->
                    <image
                        xlink:href="https://blackjackiminternet.biz/images/blackjack-im-internet2.jpg"
                        x="120" y="50" height="100" width="1175" />
                </g>
            </defs>
            
            <defs>
                <g id="generic-card-border">
                    <rect height="350" width="250" x="45" y="10" rx="30" ry="30"
                        style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
                </g>
            </defs>
            
            <!-- all black numbers -->
            <defs>
                <g id="black-2">
                    <!-- top left number -->
                    <text id="black-card-number-2" x="57" y="70" font-size="70"
                        fill="black">2
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-2" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-3">
                    <!-- top left number -->
                    <text id="black-card-number-3" x="57" y="70" font-size="70"
                        fill="black">3
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-3" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-4">
                    <!-- top left number -->
                    <text id="black-card-number-4" x="57" y="70" font-size="70"
                        fill="black">4
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-4" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-5">
                    <!-- top left number -->
                    <text id="black-card-number-5" x="57" y="70" font-size="70"
                        fill="black">5
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-5" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-6">
                    <!-- top left number -->
                    <text id="black-card-number-6" x="57" y="70" font-size="70"
                        fill="black">6
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-6" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-7">
                    <!-- top left number -->
                    <text id="black-card-number-7" x="57" y="70" font-size="70"
                        fill="black">7
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-7" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-8">
                    <!-- top left number -->
                    <text id="black-card-number-8" x="57" y="70" font-size="70"
                        fill="black">8
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-8" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-9">
                    <!-- top left number -->
                    <text id="black-card-number-9" x="57" y="70" font-size="70"
                        fill="black">9
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-9" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-10">
                    <!-- top left number -->
                    <text id="black-card-number-10" x="57" y="70" font-size="60"
                        fill="black">10
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-10" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="black-A">
                    <!-- top left number -->
                    <text id="black-card-number-A" x="57" y="70" font-size="70"
                        fill="black">A
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#black-card-number-A" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            
            <!-- all red numbers -->
            <defs>
                <g id="red-2">
                    <!-- top left number -->
                    <text id="red-card-number-2" x="57" y="70" font-size="70"
                        fill="red">2
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-2" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-3">
                    <!-- top left number -->
                    <text id="red-card-number-3" x="57" y="70" font-size="70"
                        fill="red">3
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-3" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-4">
                    <!-- top left number -->
                    <text id="red-card-number-4" x="57" y="70" font-size="70"
                        fill="red">4
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-4" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-5">
                    <!-- top left number -->
                    <text id="red-card-number-5" x="57" y="70" font-size="70"
                        fill="red">5
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-5" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-6">
                    <!-- top left number -->
                    <text id="red-card-number-6" x="57" y="70" font-size="70"
                        fill="red">6
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-6" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-7">
                    <!-- top left number -->
                    <text id="red-card-number-7" x="57" y="70" font-size="70"
                        fill="red">7
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-7" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-8">
                    <!-- top left number -->
                    <text id="red-card-number-8" x="57" y="70" font-size="70"
                        fill="red">8
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-8" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-9">
                    <!-- top left number -->
                    <text id="red-card-number-9" x="57" y="70" font-size="70"
                        fill="red">9
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-9" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-10">
                    <!-- top left number -->
                    <text id="red-card-number-10" x="57" y="70" font-size="60"
                        fill="red" >10
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-10" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-A">
                    <!-- top left number -->
                    <text id="red-card-number-A" x="57" y="70" font-size="70"
                        fill="red" >A
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-A" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            
            <!-- all 4 card types -->
            <defs>
                <g id="hearts">
                    <!-- top middle heart -->
                    <polygon points="170,160 130,115 210,115" style="stroke:red;fill:red;stroke-width:1" />
                    <circle cx="150" cy="109" r="20" style="stroke:red;fill:red" />
                    <circle cx="190" cy="109" r="20" style="stroke:red;fill:red" />
                    
                    <!-- bottom middle heart -->
                    <polygon points="170,210 130,255 210,255" style="stroke:red;fill:red;stroke-width:1" />
                    <circle cx="150" cy="261" r="20" style="stroke:red;fill:red" />
                    <circle cx="190" cy="261" r="20" style="stroke:red;fill:red" />
                    
                    <!--small top heart-->
                    <polygon points="80,120 59,90 101,90" style="stroke:red;fill:red;stroke-width:1"/>
                    <circle cx="70" cy="90" r="10" style="stroke:red;fill:red"/>
                    <circle cx="90" cy="90" r="10" style="stroke:red;fill:red"/>
                    
                    <!--small bottom heart-->
                    <polygon points="260,250 237,280 282,280" style="stroke:red;fill:red;stroke-width:1"/>
                    <circle cx="250" cy="280" r="10" style="stroke:red;fill:red"/>
                    <circle cx="270" cy="280" r="10" style="stroke:red;fill:red"/>
                    
                </g>
            </defs>
            
            <defs>
                <g id="diamonds">
                    <!-- top middle diamond -->
                    <polygon points="170,50 140,100 170,150 200,100" style="fill:red;stroke:red;stroke-width:1" />
                    
                    <!-- bottom middle diamond -->
                    <polygon points="170,210 140,260 170,310 200,260" style="fill:red;stroke:red;stroke-width:1" />
                    
                    <!-- small top diamond-->
                    <polygon points="90,80 75,105 90,130 105,105" style="fill:red;stroke:red;stroke-width:1" />
                    
                    <!--small bottom diamond -->
                    <polygon points="250,235 235,260 250,285 265,260" style="fill:red;stroke:red;stroke-width:1" />
           
                  
                </g>
            </defs>
            
            <defs>
                <g id="clubs">
                    <!-- top middle suit -->
                    <image x="135" y="60" width="80" height="80"
                        xlink:href="http://www.bikerstammtisch.com/Poker/Kreuz1.png" />
                    
                    <!-- bottom middle suit -->
                    <image x="135" y="220" width="80" height="80"
                        xlink:href="http://www.bikerstammtisch.com/Poker/Kreuz1.png"
                        transform="rotate(180, 175, 265)" />
                    <!-- small top suit-->
                    <image x="57" y="80" width="50" height="50"
                        xlink:href="http://www.bikerstammtisch.com/Poker/Kreuz1.png" />
                    <!-- small bottom suit-->
                    <image x="65" y="240" width="50" height="50"
                        xlink:href="http://www.bikerstammtisch.com/Poker/Kreuz1.png"
                        transform="rotate(180, 175, 265)" />
                    
                </g>
            </defs>
            
            <defs>
                <g id="spades">
                    
                    <!-- top middle spade -->
                    <polygon points="170,80 130,125 210,125" style="stroke-width:1" />
                    <circle cx="150" cy="131" r="20" />
                    <circle cx="190" cy="131" r="20" />
                    <line x1="170" y1="120" x2="170" y2="175" style="stroke:black;fill:black;stroke-width:10" />
                    
                    <!-- bottom middle spade -->
                    <polygon points="170,300 130,255 210,255" style="fill:black;stroke:black;stroke-width:1" />
                    <circle cx="150" cy="249" r="20" style="stroke:black;fill:black" />
                    <circle cx="190" cy="249" r="20" style="stroke:black;fill:black" />
                    <line x1="170" y1="205" x2="170" y2="260" style="stroke:black;fill:black;stroke-width:10" />
                    
                    <!--small top spade-->
                    <polygon points="80,80 59,110 101,110" style="stroke:black;fill:black;stroke-width:1"/>
                    <circle cx="70" cy="110" r="10" style="stroke:black;fill:black"/>
                    <circle cx="90" cy="110" r="10" style="stroke:black;fill:black"/>
                    <line x1="80" y1="110" x2="80" y2="130" style="stroke:black;fill:black;stroke-width:5" />
                    
                    <!--small bottom spade-->
                    <polygon points="260,280 237,250 282,250" style="stroke:black;fill:black;stroke-width:1"/>
                    <circle cx="250" cy="250" r="10" style="stroke:black;fill:black"/>
                    <circle cx="270" cy="250" r="10" style="stroke:red;fill:black"/>
                    <line x1="260" y1="250" x2="260" y2="230" style="stroke:black;fill:black;stroke-width:5" />
                    
                </g>
            </defs>
            
            
            <!-- all special cards (with pics) -->
            <!-- diamonds -->
            <defs>
                <g id="diamonds-K">
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/67/500_F_40036731_mPYQRYDtnqpLXIqxewu5bmq5q8ItclVE.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="diamonds-Q">
                    <use xlink:href="#generic-card-border" />
                    <image xlink:href="
                        https://t4.ftcdn.net/jpg/00/40/22/75/500_F_40227576_KVEzuQcMDkW9KrFNoVIhTBjaKwAiWnnh.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="diamonds-J">
                    <use xlink:href="#generic-card-border" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/66/500_F_40036663_ezasrJwmIyGGPlLptnFD76PPm9wukzyF.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <!-- hearts -->
            <defs>
                <g id="hearts-K">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036471_ezXtaJezu9hsSeuk6CpQHVm2zXaH8WZd.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="hearts-Q">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036449_s0yWNKg9MyFrZ4siWskMTxvdFEltiFIQ.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="hearts-J">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036415_56z5BJ2vcHYOW34CG3xdpDDPRH2VKGMF.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <!-- clubs -->
            <defs>
                <g id="clubs-K">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/70/500_F_40037001_yiHav7FQ1ww6Tl5PbQXI0wGRF0CBLigA.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="clubs-Q">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/22/76/500_F_40227647_m0JvJccVZuHargU9QnT0s7gqkU55VC47.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="clubs-J">
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/69/500_F_40036926_6E84Mh57txnlb6a3LhA58y0I5ELGAQL6.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <!-- spades -->
            <defs>
                <g id="spades-K">
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/72/500_F_40037201_OzwAPPdNIESKCALqZ1UZTrUHC1ub8csM.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="spades-Q">
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/71/500_F_40037169_qHdy4yyUxubUewdd6MKK84tRy2zLkFsR.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <defs>
                <g id="spades-J">
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/71/500_F_40037139_yHRxBbB4ITnfYJ7AW0CDqszVJ9wiR0HG.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            
            <!-- Player 1 -->
            <xsl:for-each select="$player1/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz1*5-44 + (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(-60 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz1*5-44 + (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz1*5 -44+ (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#{$color}" transform="scale(0.2)rotate(-60 0 0)" />
                        <use x="{($xKartenplatz1*5 -44 + (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz1*5 -44  + (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#{$color}" transform="scale(0.2) rotate(-60 0 0)" />
                        <use x="{($xKartenplatz1*5 -44  + (80*$counter))}" y="{$yKartenplatz1*5-8}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 2 -->
            <xsl:for-each select="$player2/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz2*5-44 + (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(-30 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz2*5-44 + (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-30 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz2*5 -44+ (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#{$color}" transform="scale(0.2)rotate(-30 0 0)" />
                        <use x="{($xKartenplatz2*5 -44 + (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(-30 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz2*5 -44  + (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#{$color}" transform="scale(0.2) rotate(-30 0 0)" />
                        <use x="{($xKartenplatz2*5 -44  + (80*$counter))}" y="{$yKartenplatz2*5-8}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(-30 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 3 -->
            <xsl:for-each select="$player3/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz3*5-44 + (80*$counter))}" y="{$yKartenplatz3*5 -8}" xlink:href="#generic-card-border" transform="scale(0.2)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz3*5-44 + (80*$counter))}" y="{$yKartenplatz3*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz3*5 -44+ (80*$counter))}" y="{$yKartenplatz3*5-8}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatz3*5 -44 + (80*$counter))}" y="{$yKartenplatz3*5-8}" xlink:href="#red-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz3*5 -44  + (80*$counter))}" y="{$yKartenplatz3*5-8}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatz3*5 -44  + (80*$counter))}" y="{$yKartenplatz3*5-8}" xlink:href="#black-{$value}" transform="scale(0.2)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 4 -->
            <xsl:for-each select="$player4/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz4*5-44 + (80*$counter))}" y="{$yKartenplatz4*5 -8}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(30 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz4*5-44 + (80*$counter))}" y="{$yKartenplatz4*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(30 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz4*5 -44+ (80*$counter))}" y="{$yKartenplatz4*5-8}" xlink:href="#{$color}" transform="scale(0.2)rotate(30 0 0)" />
                        <use x="{($xKartenplatz4*5 -44+ (80*$counter))}" y="{$yKartenplatz4*5-8}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(30 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz4*5 -44  + (80*$counter))}" y="{$yKartenplatz4*5-8}" xlink:href="#{$color}" transform="scale(0.2) rotate(30 0 0)" />
                        <use x="{($xKartenplatz4*5 -44  + (80*$counter))}" y="{$yKartenplatz4*5-8}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(30 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 5 -->
            <xsl:for-each select="$player5/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz5*5-44 + (80*$counter))}" y="{$yKartenplatz5*5 -8}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(60 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz5*5-44 + (80*$counter))}" y="{$yKartenplatz5*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz5*5 -44+ (80*$counter))}" y="{$yKartenplatz5*5-8}" xlink:href="#{$color}" transform="scale(0.2)rotate(60 0 0)" />
                        <use x="{($xKartenplatz5*5 -44 + (80*$counter))}" y="{$yKartenplatz5*5-8}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(60 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz5*5 -44  + (80*$counter))}" y="{$yKartenplatz5*5-8}" xlink:href="#{$color}" transform="scale(0.2) rotate(60 0 0)" />
                        <use x="{($xKartenplatz5*5 -44  + (80*$counter))}" y="{$yKartenplatz5*5-8}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(60 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Dealer -->
            <xsl:for-each select="dealer/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatzDealer*5-44 + (80*$counter))}" y="{$yKartenplatzDealer*5 -8}" xlink:href="#generic-card-border" transform="scale(0.2)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatzDealer*5-44 + (80*$counter))}" y="{$yKartenplatzDealer*5-8}" xlink:href="#{$color}-{$value}" transform="scale(0.2) " />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatzDealer*5 -44+ (80*$counter))}" y="{$yKartenplatzDealer*5-8}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatzDealer*5 -44 + (80*$counter))}" y="{$yKartenplatzDealer*5-8}" xlink:href="#red-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatzDealer*5 -44  + (80*$counter))}" y="{$yKartenplatzDealer*5-8}" xlink:href="#{$color}" transform="scale(0.2) " />
                        <use x="{($xKartenplatzDealer*5 -44  + (80*$counter))}" y="{$yKartenplatzDealer*5-8}" xlink:href="#black-{$value}" transform="scale(0.2)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!--Animationen-->
            <defs>
                <animateMotion xlink:href="#Coin1" dur="3s" path="M0 0 l+200 +200" fill="freeze" calcMode="discrete"/>
                <animateMotion xlink:href="#Coin2" dur="6s" path="M0 0 l+200 +200" rotate="45"/>
                <animateMotion xlink:href="#Coin3" dur="3s" path="M0 0 l+200 +200" />
            </defs>
            
            
                
           
            
            <defs>
                <rect id="button" width="{$widthButton}" height="{$heightButton}"></rect>
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
            <style>
                .button {
                background-color: #4CAF50;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                display: inline-block;
                min-width: 75px;
                font-family: Arial, Helvetica, sans-serif;
                }
                .button_disabled {
                background-color: #E6E6E6;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: default;
                display: inline-block;
                min-width: 75px;
                opacity: 0.8;
                font-family: Arial, Helvetica, sans-serif;
                }
                .button_center {
                background-color: white;
                border: solid;
                color: black;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                display: inline-block;
                min-width: 100px;
                font-family: Arial, Helvetica, sans-serif;
                }
            </style>
            
            <xsl:variable name="minBet" select="./minBet"/>
            <xsl:if test="step = 'bet'">
                    <foreignObject x="40" y="750">
                        <form action="/blackjack/bet-form/{$gameId}" style="display:flex; flex-direction:column;" xmlns="http://www.w3.org/1999/xhmtl">
                          <table>
                              <tr>
                                  <td width="50">
                                      <label for="bet">Bet: </label>
                                  </td>
                                  <td width="50">
                                      <input type="number" name="bet" id="bet" value="{$minBet}"/>
                                  </td>
                                  <td width="150">
                                      <input class = "active_button" type="submit" value="submit bet"/>
                                  </td>
                              </tr>
                          </table>
                      </form>
                    </foreignObject>
            </xsl:if>

            <xsl:if test="step = 'play'">
                <xsl:choose>
                    <xsl:when test="(dealer/hand/card[1]/value = 'A') and (players/player[@id = $playerActive]/insurance = '0')">
                        <foreignObject x="0" y="730" width="150" height="100">
                            <a href="/blackjack/insurance/{$gameId}" class="button">Insurance</a>
                        </foreignObject>
                    </xsl:when>
                    <xsl:otherwise>
                        <foreignObject x="0" y="730" width="150" height="100">
                            <a href="/blackjack/insurance/{$gameId}" class="button_disabled">Insurance</a>
                        </foreignObject>
                    </xsl:otherwise>
                </xsl:choose>
                
                <foreignObject x="150" y="730" width="150" height="50">
                    <a href="/blackjack/hit/{$gameId}" class="button">Hit</a>
                </foreignObject>
                
                <foreignObject x="300" y="730" width="150" height="50">
                <a href="/blackjack/stand/{$gameId}" class="button">Stand</a>
                </foreignObject>
            </xsl:if>

            <xsl:if test="step = 'finishing'">
                <foreignObject x="518" y="250">
                    <a href="/blackjack/finishing/{$gameId}" class="button_center">Payout</a>
                </foreignObject>
            </xsl:if> 
            
            <xsl:if test="step = 'gameover'">
                <foreignObject x="518" y="250">
                    <a href="/blackjack/gameover/{$gameId}" class="button_center">Game Over</a>
                </foreignObject>
            </xsl:if>
            
            <xsl:if test="step = 'finished'">
                <foreignObject x="518" y="250">
                    <a href="/blackjack/finished/{$gameId}" class="button_center">Next Round</a>
                </foreignObject>
            </xsl:if>
            
            <div style="position:absolute;bottom:0;right:0;height:200px;width:390px;border:1px solid #ccc;font:16px/26px; overflow:auto;font-family:'Courier New',Verdana,sans-serif;">
                <xsl:for-each select="events/event">
                    <div>[<xsl:value-of select="time"/>] <xsl:value-of select="text"/></div>
                </xsl:for-each>
            </div>
            
        </svg>
    </xsl:template>

</xsl:stylesheet>
