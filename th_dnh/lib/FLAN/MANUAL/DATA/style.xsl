<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xml:lang="ja">
	<xsl:template name="html_header">
		<xsl:param name="caption">BlankPage</xsl:param>
		<head>
			<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
			<meta content="no-cache, must-revalidate" http-equiv="Cache-Control" />
			<meta content="no-cache" http-equiv="Pragma" />
			<meta content="JA" name="MS.LOCALE" />
			<meta content="Mc" name="author" />
			<link href="./style.css" rel="Stylesheet" />
			<link href="../index.html" rel="Start" />
			<link href="./main.xml" rel="Help" />
			<link href="./main.xml#copyright" rel="Copyright" />
			<link href="mailto:info@danmaq.com" rev="made" />
			<title><xsl:value-of select="@caption" /> - Framework of LunAtic Notation</title>
		</head>
	</xsl:template>
	<xsl:template name="put_id">
		<xsl:param name="caption"></xsl:param>
		<xsl:choose>
			<xsl:when test="count(@id)!=0">
				<xsl:value-of select="@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$caption='概要'">overview</xsl:when>
					<xsl:when test="$caption='書換可能定数'">v_ram</xsl:when>
					<xsl:when test="$caption='書換不可定数'">v_rom</xsl:when>
					<xsl:when test="$caption='メンバ変数'">v_member</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$caption" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="put_link">
		<xsl:param name="uri">main.xml</xsl:param>
		<xsl:param name="caption">caption</xsl:param>
		<xsl:param name="description"></xsl:param>
		<a target="main">
			<xsl:attribute name="href">
				<xsl:choose>
					<xsl:when test="count(@uri)!=0">
						<xsl:value-of select="@uri" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$uri" />
						#
						<xsl:call-template name="put_id">
							<xsl:with-param name="caption">
								<xsl:value-of select="$caption" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$description!=''">
				<xsl:attribute name="title">
					<xsl:value-of select="$description" />
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$caption" />
		</a>
	</xsl:template>
	<xsl:template match="contents">
		<html version="-//W3C//DTD XHTML 1.1//EN" xml:lang="ja">
			<xsl:call-template name="html_header">
				<xsl:with-param name="caption">
					<xsl:value-of select="@caption" />
				</xsl:with-param>
			</xsl:call-template>
			<body>
				<h1><xsl:value-of select="@caption" /></h1>
				<hr />
				<xsl:apply-templates select="category" />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="category">
		<xsl:if test="count(@caption)!=0">
			<h2>
				<xsl:attribute name="id">
					<xsl:call-template name="put_id">
						<xsl:with-param name="caption">
							<xsl:value-of select="@caption" />
						</xsl:with-param>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:value-of select="@caption" />
				<xsl:if test="count(define)!=0">
					(要素数:<xsl:value-of select="count(define)" />)
				</xsl:if>
			</h2>
		</xsl:if>
		<xsl:if test="count(@image)!=0">
			<p class="image">
				<img alt="" height="128" width="128">
					<xsl:attribute name="src">
						<xsl:value-of select="@image" />
					</xsl:attribute>
				</img>
			</p>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count(*)=0">
				<p>NONE</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="paragraph "/>
				<xsl:apply-templates select="list" />
				<xsl:if test="count(define)!=0">
					<dl>
						<xsl:apply-templates select="define" />
					</dl>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<hr />
	</xsl:template>
	<xsl:template match="paragraph">
		<p><xsl:apply-templates /></p>
	</xsl:template>
	<xsl:template match="define">
		<dt>
			<xsl:attribute name="id">
				<xsl:value-of select="@key" />
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test=" @type = 'var' ">
					<var><xsl:value-of select="@key" /></var>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@key" />
					<xsl:if test=" @type = 'function' or count( @type ) = 0 ">
						(引数:<xsl:value-of select="count(argument)" />)
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</dt>
		<dd>
			<xsl:if test="count(argument)!=0">
				<ol>
					<xsl:apply-templates select="argument" />
				</ol>
			</xsl:if>
			<xsl:if test="count(return)=1">
				<p class="return">
					RETURN. <xsl:apply-templates select="return" />
				</p>
			</xsl:if>
			<xsl:apply-templates select="paragraph|list" />
		</dd>
	</xsl:template>
	<xsl:template match="list">
		<ul><xsl:apply-templates select="item" /></ul>
	</xsl:template>
	<xsl:template match="argument|item">
		<li><xsl:apply-templates /></li>
	</xsl:template>
	<!--Menu -->
	<xsl:template match="index">
		<html version="-//W3C//DTD XHTML 1.1//EN" xml:lang="ja">
			<xsl:call-template name="html_header">
				<xsl:with-param name="caption">MainMenu</xsl:with-param>
			</xsl:call-template>
			<body>
				<h1>Framework of LunAtic Notation</h1>
				<address>(c)2006 danmaq</address>
				<hr />
				<ul class="menu">
					<li><a target="main" href="http://danmaq.com/products/thd/flan.xml">最新版を入手する</a></li>
					<li><a target="main" href="http://danmaq.com/feedback/test/read.cgi/board/1153556259">バグ・要望報告する</a></li>
					<li><a target="_top" href="http://danmaq.com/">ライブラリ作者のサイトへ</a></li>
				</ul>
				<hr />
				<ul class="menu">
					<xsl:apply-templates select="contents" mode="menuanchor" />
				</ul>
				<hr />
				<xsl:apply-templates select="contents" mode="menu" />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="contents" mode="menuanchor">
		<li>
			<a>
				<xsl:attribute name="href">
						#<xsl:value-of select="@file" />
				</xsl:attribute>
				<xsl:value-of select="@caption" />
			</a>
		</li>
	</xsl:template>
	<xsl:template match="contents" mode="menu">
		<h2>
			<xsl:attribute name="id">
				<xsl:value-of select="@file" />
			</xsl:attribute>
			<xsl:value-of select="@caption" />
		</h2>
		<div class="indent">
			<xsl:apply-templates select="category" mode="menu">
				<xsl:with-param name="file">
					<xsl:value-of select="@file" />.xml
				</xsl:with-param>
			</xsl:apply-templates>
		</div>
		<hr />
	</xsl:template>
	<xsl:template match="category" mode="menu">
		<xsl:param name="file">main.xml</xsl:param>
		<xsl:if test="count(@caption)!=0">
			<h3>
				<xsl:choose>
					<xsl:when test="@link='true'">
						<xsl:call-template name="put_link">
							<xsl:with-param name="uri">
								<xsl:value-of select="$file" />
							</xsl:with-param>
							<xsl:with-param name="caption">
								<xsl:value-of select="@caption" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@caption" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="count(define)!=0">
					(要素数:<xsl:value-of select="count(define)" />)
				</xsl:if>
			</h3>
			<xsl:if test="count(define)!=0 and (count(@link)=0 or @link!='true')">
				<ul class="menu">
					<xsl:apply-templates select="define" mode="menu">
						<xsl:with-param name="file">
							<xsl:value-of select="$file" />
						</xsl:with-param>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="define" mode="menu">
		<xsl:param name="file">main.xml</xsl:param>
		<li>
			<xsl:call-template name="put_link">
				<xsl:with-param name="uri">
					<xsl:value-of select="$file" />
				</xsl:with-param>
				<xsl:with-param name="caption">
					<xsl:value-of select="@key" />
				</xsl:with-param>
				<xsl:with-param name="description">(引数:<xsl:value-of select="count(argument)" />) <xsl:value-of select="paragraph/caption" /></xsl:with-param>
			</xsl:call-template>
		</li>
	</xsl:template>
	<xsl:template match="br|hr|code|var|kbd|em|strong|pre|a">
		<xsl:copy>
			<xsl:for-each select="@*">
				<xsl:copy />
			</xsl:for-each>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="comment">
		<span class="comment"><xsl:apply-templates /></span>
	</xsl:template>
	<xsl:template match="header">
		<span class="header"><xsl:apply-templates /></span>
	</xsl:template>
	<xsl:template match="value">
		<samp><xsl:apply-templates /></samp>
	</xsl:template>
	<xsl:template match="path">
		<kbd><xsl:apply-templates /></kbd>
	</xsl:template>
	<xsl:template match="caution">
		<strong>注意 : </strong><em><xsl:apply-templates /></em>
	</xsl:template>
</xsl:stylesheet>
