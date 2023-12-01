@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Applications'
define root view entity ZINN_I_APPLICATIONS as select from zinn_application
association [0..*] to ZINN_I_APPLICATIONSTEXT as _applicationstext
on $projection .applicationid = _applicationstext.Applicationid
composition [0..*] of ZINN_I_INSTALLATIONS as _installations 
{

    key applicationid as applicationid,
    applicationname,
    @ObjectModel.text.association: '_applicationstext' 
    _applicationstext[ Spras = $session.system_language ].Applicationdesc,     
    applicationguide,
    applicationimage,
    traininghours,
    mimetype,    
    filename,
    @Semantics.user.createdBy: true
    createdby as createdby,
    @Semantics.systemDateTime.createdAt: true
    createdat as createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as lastchangedat,
    _applicationstext, 
    _installations
    
   
}

