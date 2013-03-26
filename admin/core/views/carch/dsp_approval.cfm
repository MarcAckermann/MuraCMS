
<cfoutput>
<cfif requiresApproval and listFindNoCase('Pending,Rejected',rc.contentBean.getApprovalStatus())  >
<p class="alert alert-error">
	<cfif rc.contentBean.getApprovalStatus() eq 'Rejected'>
		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.rejectedmessage")#: 
	<cfelseif rc.contentBean.getApprovalStatus() eq 'Cancelled'>
		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.cancelledmessage")#: 
	<cfelse>
		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.pendingmessage")#: 
	</cfif>
	<strong><a href="##" onclick="return viewApprovalInfo('#JSStringFormat(rc.contentBean.getContentHistID())#','#JSStringFormat(rc.contentBean.getSiteID())#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewdetails")#</a></strong>
</p>
</cfif>
<script>
function viewApprovalInfo(contenthistid,siteid){
	
	var url = 'index.cfm';
	var pars = 'muraAction=cArch.approvalmodal&compactDisplay=true&siteid=' + siteid  + '&contenthistid=' + contenthistid +'&cacheid=' + Math.random();
	var d = jQuery('##approvalModalContainer');
	d.html('<div class="load-inline"></div>');
	$.get(url + "?" + pars, 
			function(data) {
			jQuery('##approvalModalContainer').html(data);
			stripe('stripe');
			});
		
		$("##approvalModalContainer").dialog({
			resizable: false,
			modal: true
		});
	
	
	return false;	
}

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
						var href = window.location.href.replace('#rc.contentBean.getContentHistID()#',data.contenthistid);
						//alert(href)
						window.location = href;
					}
				);
			}
		);
	}
}
</script>
<div style="display:none" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#rc.contentBean.getApprovalStatus()#"))#" id="approvalModalContainer">

</div>
</cfoutput>