<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  
  <xsl:template match="PubmedArticleSet">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="PubmedArticle | PubmedBookArticle">
    <xsl:element name="Citation">
      <xsl:element name="Order">
          <xsl:number count="PubmedArticle | PubmedBookArticle" from="PubmedArticleSet" level="any"/>
      </xsl:element>
      <xsl:apply-templates select="MedlineCitation"/>
      <xsl:apply-templates select="PubmedData"/>
      <xsl:apply-templates select="BookDocument"/>
      <xsl:apply-templates select="PubmedBookData"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="DateCompleted | DateRevised | PubDate | ArticleDate">
    <xsl:variable name="date_element"><xsl:value-of select ="name(.)"/></xsl:variable>
    <xsl:variable name="date_type"><xsl:if test="@DateType != ''"><xsl:value-of select ="concat('_', @DateType)"/></xsl:if></xsl:variable>
    <xsl:variable name="Year"><xsl:if test="Year != ''"><xsl:value-of select ="Year"/></xsl:if></xsl:variable>
    <xsl:variable name="Month"><xsl:if test="Month != ''"><xsl:value-of select ="concat('-', Month)"/></xsl:if></xsl:variable>
    <xsl:variable name="Day"><xsl:if test="Day != ''"><xsl:value-of select ="concat('-', Day)"/></xsl:if></xsl:variable>
    <!-- <xsl:variable name="Hour"><xsl:if test="Hour != ''"><xsl:value-of select ="concat(' ', Hour)"/></xsl:if></xsl:variable> -->
    <!-- <xsl:variable name="Minute"><xsl:if test="Minute != ''"><xsl:value-of select ="concat(':', Minute)"/></xsl:if></xsl:variable> -->
    <!-- <xsl:variable name="Second"><xsl:if test="Second != ''"><xsl:value-of select ="concat(':', Second)"/></xsl:if></xsl:variable> -->
    <xsl:variable name="Season"><xsl:if test="Season != ''"><xsl:value-of select ="concat('-', Season)"/></xsl:if></xsl:variable>
    
    <xsl:element name="{concat($date_element, $date_type)}">
      <!-- Hour, Minute and Second have note been implemented yet. -->
      <xsl:value-of select ="concat($Year, $Month, $Day, $Season)"/>
    </xsl:element>
  </xsl:template>

  <!-- MedlineCitation -->
  <xsl:template match="MedlineCitation">
    <xsl:element name="Type">PubmedArticle</xsl:element>
    <xsl:element name="Status">
      <xsl:value-of select="@Status"/>
    </xsl:element>
    <xsl:element name="IndexingMethod">
      <xsl:value-of select="@IndexingMethod"/>
    </xsl:element>
    <xsl:element name="Owner">
      <xsl:value-of select="@Owner"/>
    </xsl:element>
    <xsl:copy-of select='PMID'/>
    <xsl:apply-templates select="DateCompleted"/>
    <xsl:apply-templates select="DateRevised"/>
    <xsl:apply-templates select="Article"/>
    <xsl:element name="Journal_Country">
      <xsl:value-of select='MedlineJournalInfo/Country'/>
    </xsl:element>
    <xsl:copy-of select='MedlineJournalInfo/MedlineTA'/>
    <xsl:copy-of select='MedlineJournalInfo/NlmUniqueID'/>
    <xsl:copy-of select='MedlineJournalInfo/ISSNLinking'/>
    <xsl:copy-of select='CitationSubset'/>
    <xsl:apply-templates select="MeshHeadingList"/>
    <xsl:apply-templates select="SupplMeshList"/>
    <xsl:apply-templates select="KeywordList"/>
    <xsl:apply-templates select="OtherAbstract"/>
    <xsl:copy-of select="NumberOfReferences"/>
    <xsl:apply-templates select="OtherID"/>
    <xsl:element name="SpaceFlightMission">
      <xsl:for-each select="SpaceFlightMission">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("{SpaceFlightMission: ", text(),"}")'/>
      </xsl:for-each>
    </xsl:element>
    <xsl:apply-templates select="SpaceFlightMission"/>
    <xsl:apply-templates select="GeneralNote"/>
    <xsl:apply-templates select="ChemicalList"/>
    <xsl:apply-templates select="InvestigatorList"/>
    <xsl:apply-templates select="CommentsCorrectionsList"/>
    <xsl:apply-templates select="GeneSymbolList"/>
    <xsl:apply-templates select="PersonalNameSubjectList"/>
    <xsl:copy-of select='CoiStatement'/>
  </xsl:template>

  <xsl:template match="GeneSymbolList">
    <xsl:element name="{name(.)}">
      <xsl:for-each select="GeneSymbol">
        <xsl:if test="position() != 1">||</xsl:if>
        <xsl:value-of select='concat("{GeneSymbol: ", text(),"}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Article">
    <xsl:element name="PubModel">
      <xsl:value-of select="@PubModel"/>
    </xsl:element>
    <xsl:apply-templates select="Journal"/>
    <xsl:copy-of select='ArticleTitle'/>
    <xsl:copy-of select='VernacularTitle'/>
    <xsl:apply-templates select="Pagination"/>
    <xsl:element name="ELocationID">
      <xsl:value-of select='concat("{", ELocationID/@EIdType,": ",ELocationID, "}")'/>
    </xsl:element>
    <xsl:apply-templates select="Abstract"/>
    <xsl:apply-templates select="AuthorList"/> 
    <xsl:copy-of select="Language"/>
    <xsl:apply-templates select="GrantList"/> 
    <xsl:apply-templates select="PublicationTypeList"/>
    <xsl:apply-templates select="ArticleDate"/>
  </xsl:template>

  <xsl:template match="Pagination">
    <xsl:element name="Pagination">
      <xsl:choose>
        <xsl:when test="MedlinePgn != ''">
          <xsl:value-of select="MedlinePgn"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="StartPage != ''">
              <xsl:value-of select="StartPage"/>
              <xsl:if test="EndPage != ''">
                <xsl:value-of select="concat('-', EndPage)"/>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Journal">
    <xsl:element name="JournalTitle"><xsl:value-of select="Title"/></xsl:element>
    <xsl:copy-of select="ISOAbbreviation"/>
    <xsl:variable name="ISSN" select="concat('ISSN_', ISSN/@IssnType)"/>
    <xsl:element name='{$ISSN}'><xsl:value-of select="ISSN"/></xsl:element>
    <xsl:copy-of select="JournalIssue/Volume"/>
    <xsl:copy-of select="JournalIssue/Issue"/>
    <xsl:apply-templates select="JournalIssue/PubDate"/>
  </xsl:template>

  <xsl:template match="Abstract | OtherAbstract">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select='@Type'/>
      <xsl:copy-of select='@Language'/>
      <xsl:for-each select="AbstractText">
        <xsl:if test="@Label">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:value-of select='concat(@Label,": ")'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='concat(" \n ", @Label,": ")'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:value-of select='text()'/>
      </xsl:for-each>
    </xsl:element>
    <xsl:copy-of select='CopyrightInformation'/>
  </xsl:template>

  <xsl:template match="AuthorList | InvestigatorList | PersonalNameSubjectList">
    <xsl:element name="{name(.)}">
      <xsl:for-each select="Author | Investigator | PersonalNameSubject">
        <xsl:variable name="CollectiveName"><xsl:if test="CollectiveName != ''"><xsl:value-of select ='concat("||CollectiveName: ", CollectiveName)'/></xsl:if></xsl:variable>
        <xsl:variable name="LastName"><xsl:if test="LastName != ''"><xsl:value-of select ='concat("||LastName: ", LastName)'/></xsl:if></xsl:variable>
        <xsl:variable name="ForeName"><xsl:if test="ForeName != ''"><xsl:value-of select ='concat("||ForeName: ", ForeName)'/></xsl:if></xsl:variable>
        <xsl:variable name="Initials"><xsl:if test="Initials != ''"><xsl:value-of select ='concat("||Initials: ", Initials)'/></xsl:if></xsl:variable>
        <xsl:variable name="Suffix"><xsl:if test="Suffix != ''"><xsl:value-of select ='concat("||Suffix: ", Suffix)'/></xsl:if></xsl:variable>
        <xsl:variable name="Identifier"><xsl:if test="Identifier != ''"><xsl:value-of select ='concat("||", Identifier/@Source, ": ", Identifier, " ")'/></xsl:if></xsl:variable>
        <xsl:variable name="AffiliationInfo"><xsl:for-each select="AffiliationInfo"><xsl:value-of select ='concat("||Affiliation ", position(), ": ", Affiliation)'/></xsl:for-each></xsl:variable>
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{Position: ", position(), $CollectiveName, $LastName, $ForeName, $Initials, $Suffix, $Identifier, $AffiliationInfo, "}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="GrantList">
    <xsl:element name="GrantList">
      <xsl:for-each select="Grant">
        <xsl:variable name="GrantID"><xsl:if test="GrantID != ''"><xsl:value-of select ='concat("||GrantID: ", GrantID)'/></xsl:if></xsl:variable>
        <xsl:variable name="Acronym"><xsl:if test="Acronym != ''"><xsl:value-of select ='concat("||Acronym: ", Acronym)'/></xsl:if></xsl:variable>
        <xsl:variable name="Agency"><xsl:if test="Agency != ''"><xsl:value-of select ='concat("||Agency: ", Agency)'/></xsl:if></xsl:variable>
        <xsl:variable name="Country"><xsl:if test="Country != ''"><xsl:value-of select ='concat("||Country: ", Country)'/></xsl:if></xsl:variable>
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{Position: ", position(), $GrantID, $Acronym, $Agency, $Country, "}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PublicationTypeList">
    <xsl:element name="PublicationTypeList">
      <xsl:for-each select="PublicationType">
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{PublicationType: ", text(), "||UI: ", @UI, "}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="MeshHeadingList">
    <xsl:element name="MeshHeadingList">
      <xsl:for-each select="MeshHeading">
        <xsl:variable name="DescriptorName"><xsl:value-of select ='concat("{", "DescriptorName: ", DescriptorName, "||UI: ", DescriptorName/@UI, "||MajorTopicYN: ", DescriptorName/@MajorTopicYN, "}")'/></xsl:variable>
        <xsl:variable name="QualifierName"><xsl:for-each select="QualifierName"><xsl:value-of select ='concat(", {QualifierName: ", text(), "||UI: ", @UI, "||MajorTopicYN: ", @MajorTopicYN, "}")'/></xsl:for-each></xsl:variable>
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("[",$DescriptorName, $QualifierName, "]")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="SupplMeshList">
    <xsl:element name="SupplMeshList">
      <xsl:for-each select="SupplMeshName">
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{SupplMeshName: ", text(), "||UI: ", @UI, "||Type: ", @Type, "}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="KeywordList">
    <xsl:element name="KeywordList">
      <xsl:copy-of select='@Owner'/>      
      <xsl:for-each select="Keyword">
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{Keyword: ", text(), "||MajorTopicYN: ", @MajorTopicYN, "}")'/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="OtherID">
    <xsl:element name="OtherID">
      <xsl:value-of select ='concat("{", "OtherID: ", text(), "||Source: ", @Source, "}")'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="GeneralNote">
    <xsl:element name="GeneralNote">
      <xsl:value-of select='concat("{", "Owner: ", @Owner,"||GeneralNote: ", text(), "}")'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ChemicalList">
    <xsl:element name="ChemicalList">
      <xsl:for-each select="Chemical">
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{NameOfSubstance: ", NameOfSubstance/text(), "||RegistryNumber: ", RegistryNumber, "||UI: ", NameOfSubstance/@UI, "}")'/> 
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CommentsCorrectionsList">
    <xsl:element name="CommentsCorrectionsList">
      <xsl:for-each select="CommentsCorrections">
        <xsl:if test="position() != 1">, </xsl:if>
        <xsl:value-of select='concat("{RefType: ", @RefType, "||PMID: ", PMID, "||RefSource: ", RefSource/text(), "}")'/> 
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PubmedData">
    <xsl:element name="History">
        <xsl:value-of select="@val"/>
      </xsl:element>
  </xsl:template>
  
  <xsl:template match="BookDocument">
    <xsl:element name="Type">PubmedBookArticle</xsl:element>
  </xsl:template>
  
  <xsl:template match="PubmedBookData">
    <xsl:element name="History">
        <xsl:value-of select="@val"/>
      </xsl:element>
  </xsl:template>

</xsl:stylesheet>