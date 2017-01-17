<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="builds | build | duration | number | fullDisplayName | result">
    <xsl:copy>
      <xsl:apply-templates select="*" >
          <xsl:sort select="number"/>
      </xsl:apply-templates>
      <xsl:if test="count(*) = 0">
        <xsl:value-of select="text()" />
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="* | text()" />
</xsl:stylesheet>
