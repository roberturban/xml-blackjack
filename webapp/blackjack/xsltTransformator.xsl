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
    <xsl:variable name="xKartenplatz1" select="number(575)"/>
    <xsl:variable name="yKartenplatz1" select="number(460)"/>
    <xsl:variable name="xKartenplatz2" select="number(475)"/>
    <xsl:variable name="yKartenplatz2" select="number(750)"/>
    <xsl:variable name="xKartenplatz3" select="number(220)"/>
    <xsl:variable name="yKartenplatz3" select="number(925)"/>
    <xsl:variable name="xKartenplatz4" select="number(510)"/>
    <xsl:variable name="yKartenplatz4" select="number(150)"/>
    <xsl:variable name="xKartenplatz5" select="number(325)"/>
    <xsl:variable name="yKartenplatz5" select="number(-115)"/>
    <xsl:variable name="xKartenplatzDealer" select="number(680)"/>
    <xsl:variable name="yKartenplatzDealer" select="number(80)"/>

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

    <!-- Variables for Buttons -->
    <xsl:variable name="widthButton" select="number(200)"/>
    <xsl:variable name="heightButton" select="number(50)"/>
    <xsl:variable name="xButtonCenter" select="number(600)"/>
    <xsl:variable name="yButton" select="number(750)"/>
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
        <xsl:variable name="player3" select="players/player[3]/name"/>
        <xsl:variable name="player4" select="players/player[4]/name"/>
        <xsl:variable name="player5" select="players/player[5]/name"/>
        <xsl:variable name="player1" select="players/player[1]/name"/>
        <xsl:variable name="player2" select="players/player[2]/name"/>

        <!-- Game board -->
        <svg xmlns="http://www.w3.org/2000/svg" width="1250" height="800">
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

            <image id="BJ-logo"
                xlink:href="/static/blackjack/img/blackjack.png"
                x="{$xLogo}" y="{$yLogo}" height="100" width="300">
            </image>

            <defs>
                <rect id="kartenplatz" height="70" width="50" rx="6"/>
            </defs>

            <use x="{$xKartenplatz1}" y="{$yKartenplatz1}" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz2}" y="{$yKartenplatz2}" transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz3}" y="{$yKartenplatz3}" transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz4}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
            <use x="{$xKartenplatz5}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke="white" fill="none" />
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

            </defs>

            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[3]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                    <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player3"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[3]">
                            <use xlink:href="#avatar" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                            <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player3"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[4]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                    <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player4"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[4]">
                            <use xlink:href="#avatar" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                            <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player4"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[5]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                    <text x="{$xAvatar3+25}" y="{$yAvatar3+110}" transform="rotate(60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player5"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[5]">
                            <use xlink:href="#avatar" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                            <text x="{$xAvatar3+25}" y="{$yAvatar3+110}" transform="rotate(60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player5"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[2]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                    <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player2"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[2]">
                            <use xlink:href="#avatar" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                            <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player2"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[1]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                    <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player1"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[1]">
                            <use xlink:href="#avatar" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                            <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player1"/>
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
                    <text id="black-card-number-2" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-3" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-4" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-5" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-6" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-7" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-8" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-9" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-10" x="57" y="50" font-size="35"
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
                    <text id="black-card-number-A" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-2" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-3" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-4" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-5" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-6" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-7" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-8" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-9" x="57" y="50" font-size="35"
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
                    <text id="red-card-number-10" x="57" y="50" font-size="35"
                        fill="red">10
                    </text>
                    <!-- bottom right number -->
                    <use xlink:href="#red-card-number-10" x="200" y="290"
                        transform="rotate(180, 268, 330)" />
                </g>
            </defs>
            
            <defs>
                <g id="red-A">
                    <!-- top left number -->
                    <text id="red-card-number-A" x="57" y="50" font-size="35"
                        fill="red">A
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
                </g>
            </defs>
            
            <defs>
                <g id="diamonds">
                    <!-- top middle diamond -->
                    <polygon points="170,30 140,80 170,130 200,80" style="fill:red;stroke:red;stroke-width:1" />
                    
                    <!-- bottom middle diamond -->
                    <polygon points="170,230 140,280 170,330 200,280" style="fill:red;stroke:red;stroke-width:1" />
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
                </g>
            </defs>
            
            <defs>
                <g id="spades">
                    
                    <!-- top middle peak -->
                    <polygon points="170,80 130,125 210,125" style="stroke-width:1" />
                    <circle cx="150" cy="131" r="20" />
                    <circle cx="190" cy="131" r="20" />
                    <line x1="170" y1="120" x2="170" y2="175"
                        style="stroke:black;fill:black;stroke-width:10" />
                    
                    <!-- bottom middle peak -->
                    <polygon points="170,300 130,255 210,255" style="fill:black;stroke:black;stroke-width:1" />
                    <circle cx="150" cy="249" r="20" style="stroke:black;fill:black" />
                    <circle cx="190" cy="249" r="20" style="stroke:black;fill:black" />
                    <line x1="170" y1="205" x2="170" y2="260"
                        style="stroke:black;fill:black;stroke-width:10" />
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
            <xsl:for-each select="players/player[1]/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(-60 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(-60 0 0)" />
                        <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(-60 0 0)" />
                        <use x="{($xKartenplatz3 - 25 + (50*$counter))*5}" y="{$yKartenplatz3*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 2 -->
            <xsl:for-each select="players/player[2]/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(-30 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(-30 0 0)" />
                        <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(-30 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(-30 0 0)" />
                        <use x="{($xKartenplatz2 - 25 + (50*$counter))*5}" y="{$yKartenplatz2*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(-30 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 3 -->
            <xsl:for-each select="players/player[3]/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatz1 - 25 + (50*$counter))*5}" y="{$yKartenplatz1*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 4 -->
            <xsl:for-each select="players/player[4]/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(30 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(30 0 0)" />
                        <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(30 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(30 0 0)" />
                        <use x="{($xKartenplatz4 - 25 + (50*$counter))*5}" y="{$yKartenplatz4*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(30 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Player 5 -->
            <xsl:for-each select="players/player[5]/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2) rotate(60 0 0)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2) rotate(-60 0 0)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(60 0 0)" />
                        <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2) rotate(60 0 0)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#{$color}" transform="scale(0.2) rotate(60 0 0)" />
                        <use x="{($xKartenplatz5 - 25 + (50*$counter))*5}" y="{$yKartenplatz5*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2) rotate(60 0 0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-- Dealer -->
            <xsl:for-each select="dealer/hand/card">
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="value" select="value"/>
                <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#generic-card-border" transform="scale(0.2)" />
                <xsl:choose>
                    <xsl:when test="hidden = 'true'">
                        <!-- TODO: Kartenrückseite -->
                    </xsl:when>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'J'">
                        <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#{$color}-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:when test="$color = 'diamonds' or $color = 'hearts'">
                        <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#red-{$value}" transform="scale(0.2)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#{$color}" transform="scale(0.2)" />
                        <use x="{($xKartenplatzDealer - 25 + (50*$counter))*5}" y="{$yKartenplatzDealer*5 -100}" xlink:href="#black-{$value}" transform="scale(0.2)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
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
            
            <xsl:variable name="minBet" select="./minBet"/>
            <xsl:if test="step = 'bet'">
                <switch>
                    <foreignObject x="{$xButton}" y="{$yButton}" width="500" height="100">
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
                </switch>
            </xsl:if>

            <xsl:if test="step = 'play'">
                <g class="active_button">
                    <a href="/blackjack/insurance/{$gameId}">
                      <use xlink:href="#button" x="{$xButton - 225}" y="{$yButton}"></use>
                      <text x="{$xButtonCenter - 225}" y="{$yTextButton}" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Insurance</text>
                    </a>
                </g>

                <g class="active_button">
                    <a href="/blackjack/hit/{$gameId}">
                     <use xlink:href="#button" x="{$xButton}" y="{$yButton}"></use>
                     <text x="{$xButtonCenter}" y="{$yTextButton}" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Hit</text>
                    </a>
                </g>

                <g class="active_button">
                    <a href="/blackjack/stand/{$gameId}">
                      <use xlink:href="#button" x="{$xButton + 225}" y="{$yButton}"></use>
                      <text x="{$xButtonCenter + 225}" y="{$yTextButton}" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Stand</text>
                    </a>
                </g>
            </xsl:if>


            <xsl:if test="step = 'finishing'">
               <g class="active_button">
                   <a xlink:href="/blackjack/finishing/{$gameId}" xlink:title="go on...">
                       <use xlink:href="#button" x="{$xButton}" y="250"></use>
                       <text x="{$xButtonCenter}" y="280" alignment-baseline="middle" text-anchor="middle" fill="black" font-family="Verdana">Go on...</text>
                   </a>
               </g>
            </xsl:if>
        </svg>
    </xsl:template>

</xsl:stylesheet>
