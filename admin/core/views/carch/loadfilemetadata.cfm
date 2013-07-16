<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>

 <div class="fieldset">
 	<div class="control-group">
		<label class="control-label">
			Image
		</label>
		<div class="controls">
			<img src="#fileMetaData.getUrlForImage('medium')#"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Caption
		</label>
		<div class="controls">
			<textarea id="file-caption" data-property="caption" class="filemeta span4 htmlEditor">#fileMetaData.getCaption()#</textarea>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Alt Text
		</label>
		<div class="controls">
			<input type="text" data-property="alttext" value="#HTMLEditFormat(fileMetaData.getAltText())#"  maxlength="255" class="filemeta span4">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Credits
		</label>
		<div class="controls">
			<input type="text" data-property="credits" value="#HTMLEditFormat(fileMetaData.getCredits())#"  maxlength="255" class="filemeta span4">
		</div>
	</div>
</div>	
</cfoutput>