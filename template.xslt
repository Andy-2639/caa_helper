<!--
	Copyright (C) 2017-2021 Opsmate, Inc.

	This Source Code Form is subject to the terms of the Mozilla
	Public License, v. 2.0. If a copy of the MPL was not distributed
	with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

	This software is distributed WITHOUT A WARRANTY OF ANY KIND.
	See the Mozilla Public License for details.
-->
<xsl:stylesheet version="1.0"
	exclude-result-prefixes="caa xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:caa="http://xmlns.sslmate.com/caa">

	<xsl:output
		method="html"
		encoding="UTF-8"
		indent="no"
		doctype-system="about:legacy-compat"
		omit-xml-declaration="yes" />

	<xsl:param name="caa_endpoint"/>
	<xsl:param name="certspotter_endpoint"/>

	<xsl:template mode="copy" match="comment()" priority="11"/>
	<xsl:template mode="copy" match="xhtml:*" priority="11">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates mode="copy" select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template mode="copy" match="@*|node()" priority="10">
		<xsl:copy>
			<xsl:apply-templates mode="copy" select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/" priority="20">
		<xsl:apply-templates select="/caa:page"/>
	</xsl:template>
	<xsl:template match="caa:page">
		<html lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<title><xsl:value-of select="caa:title"/></title>
				<meta name="robots" content="noarchive" />
				<link rel="icon" type="image/png" href="https://sslmate.com/assets/img/favicon.png" />
				<link rel="stylesheet" type="text/css" href="style.css" />
				<script type="text/javascript">
					var caa_endpoint = '<xsl:value-of select="$caa_endpoint"/>';
					var certspotter_endpoint = '<xsl:value-of select="$certspotter_endpoint"/>';
				</script>
				<xsl:apply-templates mode="copy" select="caa:head/node()"/>
			</head>
			<body>
				<a id="github_ribbon" href="https://github.com/SSLMate/caa_helper"></a>
				<div id="root">
					<div id="masthead">
						<h1>CAA Record Helper</h1>
						<p class="by">By <a href="https://sslmate.com">SSLMate</a></p>
						<ul class="nav">
							<li><a href=".">Generate CAA Record</a></li><xsl:text> </xsl:text>
							<li><a href="support">Who Supports CAA?</a></li><xsl:text> </xsl:text>
							<li><a href="about">About CAA</a></li>
						</ul>
					</div>

					<xsl:apply-templates mode="copy" select="caa:body/node()"/>

					<div id="footer">
						<p>&#169; 2021 Opsmate, Inc.</p>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template mode="copy" match="caa:support" priority="20">
		<table class="support">
			<thead>
				<th class="name">Software/Provider</th>
				<th class="support">Support</th>
				<th class="comments">Comments</th>
			</thead>
			<tbody>
				<xsl:apply-templates mode="support_table_row" select="caa:software|caa:provider">
					<xsl:sort select="translate(caa:name, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template mode="support_table_row" match="caa:software|caa:provider">
		<tr>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@support='no'">unsupported</xsl:when>
					<xsl:when test="@support='broken'">broken</xsl:when>
					<xsl:otherwise>supported</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<td class="name"><xsl:value-of select="caa:name"/></td>
			<td class="support">
				<xsl:choose>
					<xsl:when test="@support='no'">No</xsl:when>
					<xsl:when test="@support='broken'">Broken</xsl:when>
					<xsl:when test="caa:version">&#x2265;<xsl:value-of select="caa:version"/></xsl:when>
					<xsl:otherwise>Yes</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="comments"><xsl:apply-templates mode="copy" select="caa:comments/node()"/></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
