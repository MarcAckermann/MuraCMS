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
<cfset content=$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
<cfset content.requiresApproval()>
<cfset approvalRequest=content.getApprovalRequest()>
<cfset group=approvalRequest.getGroup()>
<cfset user=approvalRequest.getUser()>
<cfset actions=approvalRequest.getActionsIterator()>
<cfparam name="rc.mode" default="">
<cfoutput>
<cfif rc.mode eq 'frontend'>
	<h2>#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#content.getApprovalStatus()#"))#</h2>
</cfif>
<strong>Approval Status:</strong>  #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#approvalRequest.getStatus()#"))#</br>
<strong>Submitted:</strong> #LSDateFormat(parseDateTime(approvalRequest.getCreated()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(approvalRequest.getCreated()),"short")#</br>
<strong>Submitted By:</strong>  #HTMLEditFormat(user.getFullName())#</br>
<cfif approvalRequest.getStatus() eq 'Pending'>
	<strong>Waiting For Group:</strong> #HTMLEditFormat(group.getGroupName())#</br>
</cfif>

<cfif actions.hasNext()>
	<cfloop condition="actions.hasNext()">
		<cfset action=actions.next()>
		<dl>
			<dt>#UCase(action.getActionType())# by #HTMLEditFormat(action.getUser().getFullName())# on #LSDateFormat(parseDateTime(action.getCreated()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(action.getCreated()),"short")#</dt>
			<cfif len(action.getComments())>
				#HTMLEditFormat(action.getComments())#
			</cfif>
		</dl>
	</cfloop>
</cfif>

<cfif approvalRequest.getStatus() eq 'Pending' and (listfindNoCase(session.mura.membershipids,approvalRequest.getGroupID()) or $.currentUser().isAdminUser() or $.currentUser().isSuperUser())>
	<strong>Action</strong></br>
	<input class="approval-action" id="approval-approve" name="approval-action"type="radio" value="Approve" checked/> Approve</br>
	<input class="approval-action" id="approval-reject" name="approval-action" type="radio" value="Reject" checked/> Reject</br>
	<strong>Comments</strong></br>
	<textarea id="approval-comments"></textarea></br></br>
	<input type="button" class="btn" value="Apply" onclick="applyApprovalAction('#approvalRequest.getRequestID()#',$('input:radio[name=approval-action]:checked').val(),$('##approval-comments').val(),'#approvalRequest.getSiteID()#');"/>
</cfif>
<cfif rc.mode eq 'frontend'>
<script>
function applyApprovalAction(requestid,action,comment,siteid){
	
	if(action == 'Reject' && comment == ''){
		alertDialog('#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.rejectioncommentrequired"))#');
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
						window.location = top.location.replace(top.location);
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
					frontEndProxy.post({cmd:'setWidth',width:'500'});
				}
			);	
		} else {
			frontEndProxy.post({cmd:'setWidth',width:'500'});
		}
	}
});
</script>
<cfelse>
	<cfset request.layout=false>
</cfif>
</cfoutput>
