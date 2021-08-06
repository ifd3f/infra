<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- Copy all nodes -->
  <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
  </xsl:template>
  
  <!-- Installation disk -->
  <xsl:template match="/domain/devices/disk[1]">
    <xsl:copy> 
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="device">cdrom</xsl:attribute>

      <xsl:copy-of select="driver"/>
      <xsl:copy-of select="source"/>
      <xsl:copy-of select="address"/>

      <target dev="vda" bus="sata"/>
      <boot order="1" />
      <readonly />
    </xsl:copy>
  </xsl:template>
  
  <!-- Boot disk -->
  <xsl:template match="/domain/devices/disk[2]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="node()"/>
      <boot order="2" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>