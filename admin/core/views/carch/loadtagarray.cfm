<cfset request.layout=false>
<cfset tags=$.getBean('contentGateway').getTagCloud($.event('siteID')) />
<cfoutput>[<cfloop query="tags">{id: '#JSStringFormat(tags.tag)#', toString: function() { return '#JSStringFormat(tags.tag)#'; } }<cfif tags.currentrow lt tags.recordcount>,</cfif></cfloop>]</cfoutput><cfabort>