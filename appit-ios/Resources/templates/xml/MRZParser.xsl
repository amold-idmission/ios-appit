<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ids="http://www.idmission.com/ids">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template match="/">
		<!-- Variable for lines -->
		<xsl:variable name="FirstLine" select="Records/Record[1]"/>
		<xsl:variable name="SecondLine" select="Records/Record[2]"/>
		<xsl:variable name="ThirdLine" select="Records/Record[3]"/>
		<xsl:variable name="Filler" select="''"/>

		<!-- Variable for char count in each lines -->
		<xsl:variable name="FirstLineCount" select="string-length($FirstLine)"/>
		<xsl:variable name="SecondLineCount" select="string-length($SecondLine)"/>
		<xsl:variable name="ThirdLineCount" select="string-length($ThirdLine)"/>

		<IDData xmlns="http://www.idmission.com/idp">


			<!-- common nodes -->

			<MRZCode>
				<xsl:value-of select="translate(substring($FirstLine,1,2),'&lt;',$Filler)" />
			</MRZCode>
			<Country>
				<xsl:value-of select="translate(substring($FirstLine,3,3),'&lt;',$Filler)" />
			</Country>


			<xsl:choose>
				<xsl:when  test="$ThirdLineCount > 0">
					<!--  If we have 3 line ID document then call MRZ Parser for MR TD 1 -->
					<!-- ##################################### MRTD1 START ######################################################### -->

					<IDNumber>		
						<xsl:value-of select="translate(substring($FirstLine,6,9),'&lt;',$Filler)" />
					</IDNumber>
					<IDNumberCheckDigit>		
						<xsl:value-of select="translate(substring($FirstLine,15,1),'&lt;',$Filler)" />
					</IDNumberCheckDigit>
					<IDNumber2>		
						<xsl:value-of select="translate(substring($FirstLine,16,14),'&lt;',$Filler)" />
					</IDNumber2>

                    <DateofBirthMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,1,6),'&lt;',$Filler)" />
                    </DateofBirthMRZ>
					<DateofBirth>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,5,2),'&lt;',$Filler),'/',translate(substring($SecondLine,3,2),'&lt;',$Filler),'/',translate(substring($SecondLine,1,2),'&lt;',$Filler))" /> -->
						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,1,6)" />
						</xsl:call-template>
					</DateofBirth>
					<DateofBirthCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,7,1),'&lt;',$Filler)" />
					</DateofBirthCheckDigit>

					<Gender>
						<xsl:value-of select="translate(substring($SecondLine,8,1),'&lt;',$Filler)" />
					</Gender>

                    <ExpiryDateMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,9,6),'&lt;',$Filler)" />
                    </ExpiryDateMRZ>
					<ExpiryDate>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,13,2),'&lt;',$Filler),'/',translate(substring($SecondLine,11,2),'&lt;',$Filler),'/',translate(substring($SecondLine,9,2),'&lt;',$Filler))" /> -->
						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,9,6)" />
						</xsl:call-template>

					</ExpiryDate>
					<ExpiryCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,15,1),'&lt;',$Filler)" />
					</ExpiryCheckDigit>
					<Nationality>
						<xsl:value-of select="translate(substring($SecondLine,16,3),'&lt;',$Filler)" />
					</Nationality>
					<Optional2>
						<xsl:value-of select="translate(substring($SecondLine,19,11),'&lt;',$Filler)" />
					</Optional2>
                    <FinalCheckDigitString>
                        <xsl:value-of select="translate(concat(substring($FirstLine,6,25),substring($SecondLine,1,7),substring($SecondLine,9,7),substring($SecondLine,19,11)),'&lt;','0')"/>
                    </FinalCheckDigitString>
					<CheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,30,1),'&lt;',$Filler)" />
					</CheckDigit>
					<xsl:call-template name="parse-correct-name">
						<xsl:with-param name="text" select="$ThirdLine" />
					</xsl:call-template>

					<MRZType>
						<xsl:value-of select="'MRTD1'" />
					</MRZType>
                    <ValidLength>
                        <xsl:choose>
                        <xsl:when  test="$FirstLineCount = $SecondLineCount and  $SecondLineCount = $ThirdLineCount">Y</xsl:when>
                        <xsl:otherwise>N</xsl:otherwise>
                        </xsl:choose>
                    </ValidLength>
					<!-- ##################################### MRTD1 END ######################################################### -->
				</xsl:when>
				<xsl:when  test="$SecondLineCount &lt;= 39 and  $FirstLineCount  &lt;= 39">
					<!-- ##################################### MRTD2 START ######################################################### -->
					<!--  If we have 2 lines and 36 chars on each line ( +3 added as error 39=36+3) -->
					<xsl:call-template name="parse-correct-name">
						<xsl:with-param name="text" select="substring($FirstLine,6)" />
					</xsl:call-template>
					<IDNumber>		
						<xsl:value-of select="translate(substring($SecondLine,1,9),'&lt;',$Filler)" />
					</IDNumber>
					<IDNumberCheckDigit>		
						<xsl:value-of select="translate(substring($SecondLine,10,1),'&lt;',$Filler)" />
					</IDNumberCheckDigit>
					<Nationality>
						<xsl:value-of select="translate(substring($SecondLine,11,3),'&lt;',$Filler)" />
					</Nationality>

                    <DateofBirthMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,14,6),'&lt;',$Filler)" />
                    </DateofBirthMRZ>
					<DateofBirth>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,18,2),'&lt;',$Filler),'/',translate(substring($SecondLine,16,2),'&lt;',$Filler),'/',translate(substring($SecondLine,14,2),'&lt;',$Filler))" /> -->
						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,14,6)" />
						</xsl:call-template>

					</DateofBirth>
					<DateofBirthCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,20,1),'&lt;',$Filler)" />
					</DateofBirthCheckDigit>

					<Gender>
						<xsl:value-of select="translate(substring($SecondLine,21,1),'&lt;',$Filler)" />
					</Gender>

                    <ExpiryDateMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,22,6),'&lt;',$Filler)" />
                    </ExpiryDateMRZ>
					<ExpiryDate>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,26,2),'&lt;',$Filler),'/',translate(substring($SecondLine,24,2),'&lt;',$Filler),'/',translate(substring($SecondLine,22,2),'&lt;',$Filler))" /> -->
						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,22,6)" />
						</xsl:call-template>

					</ExpiryDate>
					<ExpiryCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,28,1),'&lt;',$Filler)" />
					</ExpiryCheckDigit>
					<IDNumber2>		
						<xsl:value-of select="translate(substring($SecondLine,29,7),'&lt;',$Filler)" />
					</IDNumber2>
                    <FinalCheckDigitString>
                        <xsl:value-of select="translate(concat(substring($SecondLine,1,10),substring($SecondLine,14,7),substring($SecondLine,22,14)),'&lt;',$Filler)"/>
                    </FinalCheckDigitString>
					<CheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,36,1),'&lt;',$Filler)" />
					</CheckDigit>
					<MRZType>
						<xsl:value-of select="'MRTD2'" />
					</MRZType>

                    <ValidLength>
                        <xsl:choose>
                        <xsl:when  test="$FirstLineCount = $SecondLineCount">Y</xsl:when>
                        <xsl:otherwise>N</xsl:otherwise>
                        </xsl:choose>
                    </ValidLength>
					<!-- ##################################### MRTD2 END ######################################################### -->
				</xsl:when>
				<xsl:otherwise>
					<!--  If we have 2 lines and more than 39 chars then parse it as MRP -->
					<!-- #######################################  MRP START ####################################################### -->
					<xsl:call-template name="parse-correct-name">
						<xsl:with-param name="text" select="substring($FirstLine,6)" />
					</xsl:call-template>
					<IDNumber>		
						<xsl:value-of select="translate(substring($SecondLine,1,9),'&lt;',$Filler)" />
					</IDNumber>
					<IDNumberCheckDigit>		
						<xsl:value-of select="translate(substring($SecondLine,10,1),'&lt;',$Filler)" />
					</IDNumberCheckDigit>
					<Nationality>
						<xsl:value-of select="translate(substring($SecondLine,11,3),'&lt;',$Filler)" />
					</Nationality>


                    <DateofBirthMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,14,6),'&lt;',$Filler)" />
                    </DateofBirthMRZ>
					<DateofBirth>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,18,2),'&lt;',$Filler),'/',translate(substring($SecondLine,16,2),'&lt;',$Filler),'/',translate(substring($SecondLine,14,2),'&lt;',$Filler))" /> -->
						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,14,6)" />
						</xsl:call-template>
					</DateofBirth>
					<DateofBirthCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,20,1),'&lt;',$Filler)" />
					</DateofBirthCheckDigit>

					<Gender>
						<xsl:value-of select="translate(substring($SecondLine,21,1),'&lt;',$Filler)" />
					</Gender>

                    <ExpiryDateMRZ>
                        <xsl:value-of select="translate(substring($SecondLine,22,6),'&lt;',$Filler)" />
                    </ExpiryDateMRZ>
					<ExpiryDate>
						<!-- <xsl:value-of select="concat(translate(substring($SecondLine,26,2),'&lt;',$Filler),'/',translate(substring($SecondLine,24,2),'&lt;',$Filler),'/',translate(substring($SecondLine,22,2),'&lt;',$Filler))" /> -->

						<xsl:call-template name="parse-date">
							<xsl:with-param name="text" select="substring($SecondLine,22,6)" />
						</xsl:call-template>

					</ExpiryDate>
					<ExpiryCheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,28,1),'&lt;',$Filler)" />
					</ExpiryCheckDigit>
					<IDNumber2>		
						<xsl:value-of select="translate(substring($SecondLine,29,14),'&lt;',' ')" />
					</IDNumber2>
                    <xsl:if test="string-length(translate(substring($SecondLine,43,1),'&lt;',$Filler)) != 0 ">
                        <IDNumber2CheckDigit>
                            <xsl:value-of select="translate(substring($SecondLine,43,1),'&lt;',$Filler)" />
                        </IDNumber2CheckDigit>
                    </xsl:if>
                    <FinalCheckDigitString>
                        <xsl:value-of select="translate(concat(substring($SecondLine,1,10),substring($SecondLine,14,7),substring($SecondLine,22,22)),'&lt;','0')"/>
                    </FinalCheckDigitString>
					<CheckDigit>
						<xsl:value-of select="translate(substring($SecondLine,44,1),'&lt;',$Filler)" />
					</CheckDigit>
					<MRZType>
						<xsl:value-of select="'MRP'" />
					</MRZType>
                    <ValidLength>
                        <xsl:choose>
                        <xsl:when  test="$FirstLineCount = $SecondLineCount">Y</xsl:when>
                        <xsl:otherwise>N</xsl:otherwise>
                        </xsl:choose>
                    </ValidLength>
					<!-- ############################################################################################## -->
				</xsl:otherwise>
			</xsl:choose>
		</IDData>
	</xsl:template>

	<!-- Utility templates -->
    <xsl:template name="parse-date">
        <xsl:param name="text" select="''"/>
        <xsl:param name="loop" select="'1'"/>
        <xsl:param name="date" select="''"/>
        <xsl:choose>
<xsl:when test="$text != '' and $loop &lt; 4 ">
                <xsl:if test="$loop = 1">
                    <xsl:if test="substring($text, 1,2) &lt; 30">
                        <xsl:call-template name="parse-date">
                        <xsl:with-param name="text" select="substring($text, 3 )"/>
                        <xsl:with-param name="loop" select="$loop + 1"/>
                        <xsl:with-param name="date" select="concat(20,substring($text, 1,2))"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="substring($text, 1,2) &gt; 30">
                        <xsl:call-template name="parse-date">
                        <xsl:with-param name="text" select="substring($text, 3 )"/>
                        <xsl:with-param name="loop" select="$loop + 1"/>
                        <xsl:with-param name="date" select="concat(19,substring($text, 1,2))"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$loop != 1">
                    <xsl:call-template name="parse-date">
                    <xsl:with-param name="text" select="substring($text,3 )"/>
                    <xsl:with-param name="loop" select="$loop + 1"/>
                    <xsl:with-param name="date" select="concat(substring($text, 1,2),'/',$date)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($date)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	<xsl:template name="parse-name">
		<xsl:param name="text" select="''" />
		<xsl:param name="loop" select="'1'" />
		<xsl:param name="givenNames" select="''" />
		<xsl:choose>
			<xsl:when  test="$text != '' and translate($text,'&lt;','') != '' and $loop &lt; 44 ">
				<xsl:if test="$loop = 1">
					<LastName>
						<xsl:value-of select="substring-before($text,'&lt;')" />
					</LastName>
				</xsl:if>
				<xsl:variable name="len" select="string-length(substring-before($text,'&lt;'))" />
				<xsl:choose>
					<xsl:when test="$len = 0">
						<xsl:call-template name="parse-name">
							<xsl:with-param name="text" select="substring($text, 2 )" />
							<xsl:with-param name="loop" select="$loop + 1" />
							<xsl:with-param name="givenNames" select="$givenNames" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$len != 0 and $loop = 1 ">
						<xsl:call-template name="parse-name">
							<xsl:with-param name="text" select="substring($text, 1 + $len)" />
							<xsl:with-param name="loop" select="$loop + 1" />
							<xsl:with-param name="givenNames" select="$givenNames" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$len != 0 and $loop != 1 ">
						<xsl:call-template name="parse-name">
							<xsl:with-param name="text" select="substring($text, 1 + $len)" />
							<xsl:with-param name="loop" select="$loop + 1" />
							<xsl:with-param name="givenNames" select="concat($givenNames,' ', substring-before($text,'&lt;'))" />
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<FirstName>
					<xsl:value-of select="normalize-space($givenNames)" />
				</FirstName>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

    <xsl:template name="parse-correct-name">
        <xsl:param name="text" select="''" />
        <xsl:variable name="Space" select="' '"/>
        <LastName>
            <xsl:value-of select="translate(substring-before($text,'&lt;&lt;'),'&lt;',$Space)" />
        </LastName>
        <FirstName>
            <xsl:value-of select="translate(substring-after($text,'&lt;&lt;'),'&lt;',$Space)" />
        </FirstName>
    </xsl:template>

</xsl:stylesheet>

