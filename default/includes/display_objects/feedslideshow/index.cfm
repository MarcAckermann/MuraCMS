<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfswitch expression="#$.getJsLib()#">
<cfcase value="jquery">
	<cfset loadJSLib() />
	<cfset $.addToHTMLHeadQueue("feedslideshow/htmlhead/slideshow.jquery.cfm")>
	<cf_CacheOMatic key="#arguments.object##arguments.objectid#" nocache="#$.event('nocache')#">
	<cfsilent>
	<cfparam name="hasSummary" default="true"/>
	<cfif isValid("UUID",arguments.objectID)>	
		<cfset variables.feedBean = $.getBean("feed").loadBy(feedID=arguments.objectID,siteID=arguments.siteID)>
  	<cfelse>
		<cfset variables.feedBean = $.getBean("feed").loadBy(name=arguments.objectID,siteID=arguments.siteID)>
  	</cfif>
	
	<cfif isDefined("arguments.params") and isJson(arguments.params)>
		<cfset variables.feedBean.set(deserializeJSON(arguments.params))>
	<cfelse>
		<cfset variables.feedBean.setImageSize("medium")>
		<cfif not arguments.hasSummary>
			<cfset variables.contentListFields=listDeleteAt(variables.feedBean.getDisplayList(),listFindNoCase(variables.feedBean.getDisplayList(),"Summary"))>
			<cfset variables.feedBean.setDisplayList(variables.contentListFields)>
		</cfif>
	</cfif>
  	
	<cfset editableControl.editLink = "">
	<cfset editableControl.innerHTML = "">
		
	<cfif this.showEditableObjects and objectPerm eq 'editor'>
		<cfset bean = feedBean>
		<cfset $.loadShadowBoxJS()>
		<cfset $.addToHTMLHeadQueue('editableObjects.cfm')>
		<cfset request.cacheItem=false>
			
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset adminBase="https://#application.configBean.getAdminDomain()#"/>
			<cfelse>
				<cfset adminBase="http://#application.configBean.getAdminDomain()#"/>
			</cfif>
		<cfelse>
			<cfset adminBase=""/>
		</cfif>
			
		<cfset editableControl.editLink = adminBase & "#$.globalConfig('context')#/admin/index.cfm?fuseaction=cFeed.edit">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;feedid=" & bean.getFeedID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeID=" & $.content('contentID')>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;assignmentID=" & arguments.assignmentID>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;regionID=" & arguments.regionID>
			<cfset editableControl.editLink = editableControl.editLink & "&amp;orderno=" & arguments.orderno>
			
		<cfset editableControl.innerHTML = generateEditableObjectControl(editableControl.editLink,500)>
	</cfif>
</cfsilent>
<cfif editableControl.innerHTML neq "">
	<cfoutput>#$.renderEditableObjectHeader("editableFeed editableSlideShow")#</cfoutput>
</cfif>	

	<cfif feedBean.getIsActive()>
		<cfset cssID=$.createCSSid(feedBean.renderName())>
      	<cfsilent>	
			<cfset rsPreFeed=application.feedManager.getFeed(feedBean,request.tag) />
			<cfif $.siteConfig('Extranet') eq 1 and $.event('r').restrict eq 1>
				<cfset rs=$.queryPermFilter(rsPreFeed)/>
			<cfelse>
				<cfset rs=rsPreFeed />
			</cfif>
			
			<cfset variables.iterator=$.getBean("contentIterator")>
			<cfset variables.iterator.setQuery(rs,feedBean.getNextN())>
		
			
			<cfset nextN=$.getBean('utility').getNextN(rs,feedBean.getNextN(),request.StartRow)>
			<cfset checkMeta=feedBean.getDisplayRatings() or feedBean.getDisplayComments()>
			<cfset doMeta=0 />
		  </cfsilent>
	  	<cfif  variables.iterator.hasNext()>
	  	<cfoutput>
	  	<div class="svSlideshow clearfix" id="#cssID#">
		 	<cfif variables.feedBean.getDisplayName()>
		       <#$.getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.renderName())#</#$.getHeaderTag('subHead1')#>
			</cfif>
	  		<div class="svSlides" <!---<cfif arguments.hasImage>#arguments.imageStyles.markup#</cfif>--->>
		
			#$.dspObject_Include(
				thefile='dsp_content_list.cfm',
				fields=variables.feedBean.getDisplayList(),
				type="Feed", 
				iterator= variables.iterator,
				imageSize=variables.feedBean.getImageSize(),
				imageHeight=variables.feedBean.getImageHeight(),
				imageWidth=variables.feedBean.getImageWidth()
				)#

			</div>
		</div>
		</cfoutput>
		<cfelse>
			<!-- Empty Collection '<cfoutput>#feedBean.getName()#</cfoutput>'  -->
		</cfif>
		
	<cfelse>
		<!-- Inactive Feed '<cfoutput>#feedBean.getName()#</cfoutput>' -->
	 </cfif>
	  <cfif editableControl.innerHTML neq "">
	  	<cfoutput>#renderEditableObjectFooter(editableControl.innerHTML)#</cfoutput>
	 </cfif>
	</cf_CacheOMatic>
 </cfcase>
<cfdefaultcase>
		 <!-- The Prototype js library is not currently support for the slide show functionality  -->
</cfdefaultcase>
</cfswitch>

