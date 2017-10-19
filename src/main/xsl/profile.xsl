<?xml version="1.0"?>
<!--
Copyright (c) 2016-2017 Zerocracy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to read
the Software only. Permissions is hereby NOT GRANTED to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:include href="/xsl/inner-layout.xsl"/>
  <xsl:template match="page" mode="head">
    <title>
      <xsl:text>@</xsl:text>
      <xsl:value-of select="identity/login"/>
    </title>
  </xsl:template>
  <xsl:template match="page" mode="inner">
    <xsl:if test="not(details)">
      <p>
        <xsl:text>This is the profile of </xsl:text>
        <a href="https://github.com/{owner}">
          <xsl:text>@</xsl:text>
          <xsl:value-of select="owner"/>
        </a>
        <xsl:text>.</xsl:text>
      </p>
    </xsl:if>
    <xsl:apply-templates select="details"/>
    <xsl:apply-templates select="awards"/>
    <xsl:apply-templates select="agenda"/>
  </xsl:template>
  <xsl:template match="awards[.=0]">
    <p>
      <xsl:text>There are no awards yet.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="awards[.!=0]">
    <p>
      <xsl:text>Total points: </xsl:text>
      <a href="/u/{/page/owner}/awards">
        <xsl:if test=". &gt;= 0">
          <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:value-of select="."/>
      </a>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="agenda[.=0]">
    <p>
      <xsl:text>There are no jobs in the agenda.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="agenda[.!=0]">
    <p>
      <xsl:text>Total jobs: </xsl:text>
      <a href="/u/{/page/owner}/agenda">
        <xsl:value-of select="."/>
      </a>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="details">
    <xsl:apply-templates select="vacation"/>
    <xsl:if test="count(links/link) &lt; 2">
      <p>
        <span style="color:red">
          <xsl:text>ATTENTION</xsl:text>
        </span>
        <xsl:text>: </xsl:text>
        <xsl:text>You should start talking to our bot</xsl:text>
        <xsl:text> through one of our supported media, like</xsl:text>
        <xsl:text> Telegram or Slack. More details you can find in </xsl:text>
        <a href="http://datum.zerocracy.com/pages/policy.html">
          <xsl:text>our policy</xsl:text>
        </a>
        <xsl:text>.</xsl:text>
      </p>
    </xsl:if>
    <p>
      <xsl:apply-templates select="rate"/>
      <xsl:text>; </xsl:text>
      <xsl:apply-templates select="wallet"/>
      <xsl:text>.</xsl:text>
    </p>
    <xsl:apply-templates select="projects"/>
    <xsl:apply-templates select="skills"/>
  </xsl:template>
  <xsl:template match="vacation">
    <xsl:if test=". = 'true'">
      <p>
        <xsl:text>On vacation</xsl:text>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="rate[.!='0']">
    <a href="http://datum.zerocracy.com/pages/policy.html#16">
      <xsl:text>Rate</xsl:text>
    </a>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="rate[.='0']">
    <a href="http://datum.zerocracy.com/pages/policy.html#16">
      <xsl:text>Rate</xsl:text>
    </a>
    <xsl:text> is not set yet</xsl:text>
  </xsl:template>
  <xsl:template match="wallet[info!='']">
    <a href="http://datum.zerocracy.com/pages/policy.html#20">
      <xsl:text>wallet: </xsl:text>
    </a>
    <xsl:text>: </xsl:text>
    <code>
      <xsl:value-of select="info"/>
    </code>
    <xsl:text> at </xsl:text>
    <xsl:value-of select="bank"/>
  </xsl:template>
  <xsl:template match="wallet[info='']">
    <a href="http://datum.zerocracy.com/pages/policy.html#20">
      <xsl:text>payment info</xsl:text>
    </a>
    <xsl:text> is absent</xsl:text>
  </xsl:template>
  <xsl:template match="projects[project]">
    <p>
      <xsl:value-of select="count(project)"/>
      <xsl:text> project</xsl:text>
      <xsl:if test="count(project) &gt; 1">
        <xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>: </xsl:text>
      <xsl:for-each select="project">
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <a href="/p/{.}">
          <xsl:value-of select="."/>
        </a>
      </xsl:for-each>
      <xsl:text> (</xsl:text>
      <a href="/board">
        <xsl:text>apply</xsl:text>
      </a>
      <xsl:text> for more).</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="projects[not(project)]">
    <p>
      <xsl:text>You're in no projects yet, </xsl:text>
      <a href="/board">
        <xsl:text>apply</xsl:text>
      </a>
      <xsl:text> to some of them.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="links[link]">
    <p>
      <xsl:value-of select="count(link)"/>
      <xsl:text> link</xsl:text>
      <xsl:if test="count(link) &gt; 1">
        <xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>: </xsl:text>
      <xsl:for-each select="link">
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <code>
          <xsl:value-of select="."/>
        </code>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="links[not(link)]">
    <p>
      <xsl:text>It's weird, no links?!</xsl:text>
    </p>
  </xsl:template>
</xsl:stylesheet>
