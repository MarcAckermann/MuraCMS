component extends="mura.bean.beanORM" table="tchangesetrollback" {
	property name="rollbackID" fieldtype="id";
    property name="changeset" fieldtype="many-to-one" cfc="changsetBean" fkcolumn="changesetID";
    property name="site" fieldtype="many-to-one" cfc="user" fkcolumn="siteID";   
    property name="changesetVersion" fieldtype="many-to-one" cfc="content" fkcolumn="changesetHistID"; 
    property name="previousVersion" fieldtype="many-to-one" cfc="content" fkcolumn="previousHistID";   

    function rollback(){
        var previousContent=getBean('content').loadBy(contenthistID=getValue('previousHistID'));
        //writeDump(var=previousContent.getIsNew(),abort=true);

         if(not previousContent.getIsNew()){
            //writeDump(var=previousContent.getIsNew(),abort=true);
             previousContent
                .setApprovalChainOverride(true)
                .setApproved(1)
                .save();
        }

        return this;
    }
}