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
    <xsl:variable name="xKartenplatzDealer" select="number(575)"/>
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
        <xsl:variable name="player3" select="players/player[3]"/>
        <xsl:variable name="player4" select="players/player[4]"/>
        <xsl:variable name="player5" select="players/player[5]"/>
        <xsl:variable name="player1" select="players/player[1]"/>
        <xsl:variable name="player2" select="players/player[2]"/>
        <xsl:variable name="dealer" select="dealer"/>

        <!-- Game board -->
        <svg xmlns="http://www.w3.org/2000/svg" width="1250" height="830">
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

            </defs>
            
            <xsl:choose>
                <xsl:when test="$player1/bet>0">
                    <use x="{$xCoin1}" y="{$yCoin1}" xlink:href="#chip-coin" />
                    <text x="{$xCoin1}" y="{$yCoin1}"  fill="black" text-anchor="middle" dominant-baseline="central"  >
                        <xsl:value-of select="$player1/bet"/>
                    </text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player2/bet>0">
                    <use x="{$xCoin2}" y="{$yCoin2}" xlink:href="#chip-coin" />
                    <text x="{$xCoin2}" y="{$yCoin2}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player2/bet"/>
                    </text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player3/bet>0">
                    <use x="{$xCoin3}" y="{$yCoin3}" xlink:href="#chip-coin" />
                    <text x="{$xCoin3}" y="{$yCoin3}" fill="black" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="$player3/bet"/>
                    </text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player4/bet>0">
                    <use x="{$xCoin4}" y="{$yCoin4}" xlink:href="#chip-coin" />
                    <text x="{$xCoin4}" y="{$yCoin4}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player4/bet"/>
                    </text>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$player5/bet>0">
                    <use x="{$xCoin5}" y="{$yCoin5}" xlink:href="#chip-coin" />
                    <text x="{$xCoin5}" y="{$yCoin5}" fill="black" text-anchor="middle" dominant-baseline="central" >
                        <xsl:value-of select="$player5/bet"/>
                    </text>
                </xsl:when>
            </xsl:choose>
  
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[3]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                    <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player3/name"/>
                    </text>
                    <text x="{$xAvatar1+25}" y="{$yAvatar1+135}" fill="grey" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="concat('Balance: ',$player3/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[3]">
                            <use xlink:href="#avatar" x="{$xAvatar1}" y="{$yAvatar1}"></use>
                            <text x="{$xAvatar1+25}" y="{$yAvatar1+110}" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player3/name"/>
                            </text>
                            <text x="{$xAvatar1+25}" y="{$yAvatar1+135}" fill="grey" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="concat('Balance: ',$player3/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[4]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                    <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player4/name"/>
                    </text>
                    <text x="{$xAvatar2+25}" y="{$yAvatar2+135}" transform="rotate(30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="concat('Balance: ',$player4/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[4]">
                            <use xlink:href="#avatar" x="{$xAvatar2}" y="{$yAvatar2}" transform="rotate(30 0 0)"></use>
                            <text x="{$xAvatar2+25}" y="{$yAvatar2+110}" transform="rotate(30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player4/name"/>
                            </text>
                            <text x="{$xAvatar2+25}" y="{$yAvatar2+135}" transform="rotate(30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="concat('Balance: ',$player4/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[5]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                    <text x="{$xAvatar3+25}" y="{$yAvatar3+110}" transform="rotate(60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player5/name"/>
                    </text>
                    <text x="{$xAvatar3+25}" y="{$yAvatar3+135}" transform="rotate(60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="concat('Balance: ',$player5/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[5]">
                            <use xlink:href="#avatar" x="{$xAvatar3}" y="{$yAvatar3}" transform="rotate(60 0 0)"></use>
                            <text x="{$xAvatar3+25}" y="{$yAvatar3+110}" transform="rotate(60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player5/name"/>
                            </text>
                            <text x="{$xAvatar3+25}" y="{$yAvatar3+135}" transform="rotate(60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="concat('Balance: ',$player5/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[2]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                    <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player2/name"/>
                    </text>
                    <text x="{$xAvatar4+25}" y="{$yAvatar4+135}" transform="rotate(-30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="concat('Balance: ',$player2/balance)"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[2]">
                            <use xlink:href="#avatar" x="{$xAvatar4}" y="{$yAvatar4}" transform="rotate(-30 0 0)"></use>
                            <text x="{$xAvatar4+25}" y="{$yAvatar4+110}" transform="rotate(-30 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player2/name"/>
                            </text>
                            <text x="{$xAvatar4+25}" y="{$yAvatar4+135}" transform="rotate(-30 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="concat('Balance: ',$player2/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="activePlayer/@id = players/player[1]/@id">
                    <use xlink:href="#avatar_active" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                    <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="white" text-anchor="middle" dominant-baseline="central">
                      <xsl:value-of select="$player1/name"/>
                    </text>
                    <text x="{$xAvatar5+25}" y="{$yAvatar5+135}" transform="rotate(-60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                        <xsl:value-of select="concat('Balance: ',$player1/balance)"/>
                    </text>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="players/player[1]">
                            <use xlink:href="#avatar" x="{$xAvatar5}" y="{$yAvatar5}" transform="rotate(-60 0 0)"></use>
                            <text x="{$xAvatar5+25}" y="{$yAvatar5+110}" transform="rotate(-60 0 0)" fill="black" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="$player1/name"/>
                            </text>
                            <text x="{$xAvatar5+25}" y="{$yAvatar5+135}" transform="rotate(-60 0 0)" fill="grey" text-anchor="middle" dominant-baseline="central">
                                <xsl:value-of select="concat('Balance: ',$player1/balance)"/>
                            </text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

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
          
            <!-- show cards
            black cards (#kartenplatz as placeholder), template match missing for values, see: https://stackoverflow.com/questions/18585309/how-to-call-template-with-name-as-a-variable-in-xslt-->
            
            <xsl:for-each select="$player1/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                        <use x="{$xKartenplatz1 - 15+ position()*15}" y="{$yKartenplatz1}" transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatz1 - 15 + position()*15}" y="{$yKartenplatz1}"  transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatz1 - 15 + position()*15}" y="{$yKartenplatz1}"  transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke= "white"/>
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatz1 -15 + position()*15}" y="{$yKartenplatz1}" transform="rotate(-60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            
            <xsl:for-each select="$player2/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                        <use x="{$xKartenplatz2 - 15+ position()*15}" y="{$yKartenplatz2}" transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatz2 - 15 + position()*15}" y="{$yKartenplatz2}"  transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatz2 - 15 + position()*15}" y="{$yKartenplatz2}"  transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke= "white"/>
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatz2 -15 + position()*15}" y="{$yKartenplatz2}" transform="rotate(-30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            
 
            
            <xsl:for-each select="$player3/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                      <use x="{$xKartenplatz3 - 15+ position()*15}" y="{$yKartenplatz3}" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatz3 - 15 + position()*15}" y="{$yKartenplatz3}" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatz3 - 15 + position()*15}" y="{$yKartenplatz3}" xlink:href="#kartenplatz" stroke= "white"/>
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatz3 -15 + position()*15}" y="{$yKartenplatz3}" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            
            <xsl:for-each select="$player4/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                        <use x="{$xKartenplatz4 - 15+ position()*15}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatz4 - 15 + position()*15}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatz4 - 15 + position()*15}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatz4 -15 + position()*15}" y="{$yKartenplatz4}" transform="rotate(30 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            
            <xsl:for-each select="$player5/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                        <use x="{$xKartenplatz5 - 15+ position()*15}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatz5 - 15 + position()*15}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatz5 - 15 + position()*15}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke= "white"/>
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatz5 -15 + position()*15}" y="{$yKartenplatz5}" transform="rotate(60 0 0)" xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            <xsl:for-each select="$dealer/hand/card">
                <xsl:choose>
                    <xsl:when test= "self::node()/color='diamonds'">
                        <use x="{$xKartenplatzDealer - 15+ position()*15}" y="{$yKartenplatzDealer}"  xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='hearts'">
                        <use x="{$xKartenplatzDealer - 15 + position()*15}" y="{$yKartenplatzDealer}"  xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                    <xsl:when test= "self::node()/color='spades'">
                        <use x="{$xKartenplatzDealer - 15 + position()*15}" y="{$yKartenplatzDealer}" xlink:href="#kartenplatz" stroke= "white"/>
                    </xsl:when>
                    <xsl:when test= "self::node()/color='clubs'">
                        <use x="{$xKartenplatzDealer -15 + position()*15}" y="{$yKartenplatzDealer}"  xlink:href="#kartenplatz" stroke= "white" />
                    </xsl:when>
                </xsl:choose> 
            </xsl:for-each>
            
        </svg>
    </xsl:template>

</xsl:stylesheet>
