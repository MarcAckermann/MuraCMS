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
<cfsilent>
	<cfset content=$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
	<cfset $.event('contentBean',content)>
	<cfset requiresApproval=content.requiresApproval()>
	<cfset user=content.getUser()>

	<cfif requiresApproval>
		<cfset approvalRequest=content.getApprovalRequest()>
		<cfset group=approvalRequest.getGroup()>
		<cfset actions=approvalRequest.getActionsIterator()>
		<cfif user.getIsNew()>
			<cfset user=approvalRequest.getUser()>
		</cfif>
	</cfif>
	<cfparam name="rc.mode" default="">
</cfsilent>
<cfoutput>
<cfif rc.mode eq 'frontend'>
	<h1>#application.rbFactory.getKeyValue(session.rb,'layout.status')#</h1>
<div class="well">
	<!---
	<cfif requiresApproval>
		<h2>#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#content.getApprovalStatus()#"))#</h2>
	<cfelse>
		<cfif $.content('active') gt 0 and  $.content('approved')  gt 0>
			<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#</h2>
		<cfelseif len($.content('approvalStatus')) and $.content().requiresApproval() >
			<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#$.content('approvalstatus')#")#</h2>
		<cfelseif $.content('approved') lt 1>
			<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#</h2>
		<cfelse>
			<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#</h2>
		</cfif>
	</cfif>
	--->
</cfif>
<!--- <div class="well"> --->
<div class="mura-list-grid">
	<dl>
		<dt>Created By</dt> 
		<dd>
			<i class="icon-user"></i>
			<p><cfif not user.getIsNew()>#HTMLEditFormat(user.getFullName())# <cfelse> #application.rbFactory.getKeyValue(session.rb,"sitemanager.content.na")# </cfif></p>
		</dd>
	</dl>
	
	<dl>
		<dt>Created On</dt>
		<dd>
			<i class="icon-calendar"></i>
			<p>#LSDateFormat(parseDateTime(content.getLastUpdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(content.getLastUpdate()),"short")#</p>
		</dd>
	</dl>
	
	<dl>
		<dt>Status</dt>
		<dd>
			<i class="icon-ok-sign"></i>
			<p><cfif content.getactive() gt 0 and content.getapproved() gt 0>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
			<cfelseif len(content.getApprovalStatus()) and requiresApproval >
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#content.getApprovalStatus()#")#
			<cfelseif content.getapproved() lt 1>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#
			<cfelse>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#
			</cfif></p>
		</dd>
	</dl>
		
	
		<cfif $.siteConfig('hasChangesets')>
		<cfset changeset=$.getBean('changeset').loadBy(changesetID=content.getChangesetID())>
		<dl class="change-set">
			<dt>Change Set</dt>
			<dd>
				<i class="icon-list"></i>
				<p><cfif changeset.getIsNew()>Not Assigned<cfelse>#HTMLEditFormat(changeset.getName())#</cfif></p>
			</dd>
		</dl>
		</cfif>

		<!---
<dl class="comments">
			<dt>Comments</dt>
			<dd><i class="icon-comment"></i><p>Lorem ipsum dolor sit amet adspicing nonummy.</p>
				<em>by Malcolm O'Keeffe on 8/10/13</em>
			</dd>
		</dl>
		
		<dl class="approval-action-form">
				<dt>Action</dt>
				<dd>
					<label class="radio inline">
						<input class="approval-action" id="approval-approve" name="approval-action"type="radio" value="Approve" checked/>Approve
					</label>
					<label class="radio inline">
						<input class="approval-action" id="approval-reject" name="approval-action" type="radio" value="Reject" checked/>Reject
					</label>
					<p>Comments</p>
					<textarea id="approval-comments" rows="4"></textarea>
				<input type="button" class="btn btn-primary" value="Apply"/></dd>
				</dd>
				</dl>
--->
					
		
		<cfif requiresApproval>
			<cfif not content.getApproved() and approvalRequest.getStatus() eq 'Pending'>
			<dl class="approval-status">
				<dt>Approval Status</dt>
				<dd>
					<i class="icon-time"></i>
					 <cfif group.getType() eq 1>
						<em>#application.rbFactory.getKeyValue(session.rb,"approvalchains.waitingforgroup")#:</em>
						<p>#HTMLEditFormat(group.getGroupName())#</p>
					<cfelse>
						<em>#application.rbFactory.getKeyValue(session.rb,"approvalchains.waitingforuser")#:</em>
						<p>#HTMLEditFormat(action.getUser().getFullName())#</p>
					</cfif>
				</dd>
			</dl>
			</cfif>
	</div>
		
			<cfif actions.hasNext()>
				<cfloop condition="actions.hasNext()">
					<cfset action=actions.next()>
					<dl class="comments">
						<dt>Comments</dt>
						<cfif len(action.getComments())>
							<dd>
								<i class="icon-comment"></i>
								<p>#HTMLEditFormat(action.getComments())#</p>
								<em>#UCase(action.getActionType())# by #HTMLEditFormat(action.getUser().getFullName())# on #LSDateFormat(parseDateTime(action.getCreated()),session.dateKeyFormat)# at #LSTimeFormat(parseDateTime(action.getCreated()),"short")#</em>
							</dd>
						</cfif>
					</dl>
				</cfloop>
			</cfif>
		
			<cfif not content.getApproved() and approvalRequest.getStatus() eq 'Pending' and (listfindNoCase(session.mura.membershipids,approvalRequest.getGroupID()) or $.currentUser().isAdminUser() or $.currentUser().isSuperUser())>
				<dl class="approval-action-form">
				<dt>#application.rbFactory.getKeyValue(session.rb,"approvalchains.action")#</dt>
				<dd>
					<label class="radio inline">
						<input class="approval-action" id="approval-approve" name="approval-action"type="radio" value="Approve" checked/> #application.rbFactory.getKeyValue(session.rb,"approvalchains.approve")# 
					</label>
					<label class="radio inline">
						<input class="approval-action" id="approval-reject" name="approval-action" type="radio" value="Reject" checked/> #application.rbFactory.getKeyValue(session.rb,"approvalchains.reject")#
					</label>
					
				<p>#application.rbFactory.getKeyValue(session.rb,"approvalchains.comments")#</p>
				<textarea id="approval-comments" rows="4"></textarea>
				<input type="button" class="btn btn-primary" value="Apply" onclick="applyApprovalAction('#approvalRequest.getRequestID()#',$('input:radio[name=approval-action]:checked').val(),$('##approval-comments').val(),'#approvalRequest.getSiteID()#');"/>
				</dd>
				</dl>
			</cfif>
		</cfif>
<!--- </div> --->


<cfif rc.mode eq 'frontend'>
</div>
	<cfif not content.getApproved() and requiresApproval>
		<script>
		function applyApprovalAction(requestid,action,comment,siteid){
			
			if(action == 'Reject' && comment == ''){
				alertDialog('#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"approvalchains.rejectioncommentrequired"))#');
			} else {
				var pars={
							muraAction:'carch.approvalaction',
							siteid: siteid,
							requestid: requestid,
							comment: comment,
							action:action
						};

				actionModal(
					function(){
						$.post('index.cfm',
							pars,
							function(data) {
								//$('html').html(data);
								//alert(data.previewurl)
								top.location.replace(data.previewurl);
							}
						);
					}
				);
			}
		}

		$(document).ready(function(){
			if (top.location != self.location) {
				if(jQuery("##ProxyIFrame").length){
					jQuery("##ProxyIFrame").load(
						function(){
							frontEndProxy.post({cmd:'setWidth',width:'configurator'});
						}
					);	
				} else {
					frontEndProxy.post({cmd:'setWidth',width:'configurator'});
				}
			}
		});
		</script>
	</cfif>
<cfelse>
	<cfset request.layout=false>
</cfif>
</cfoutput>
