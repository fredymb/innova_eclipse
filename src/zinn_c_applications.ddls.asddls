@EndUserText.label: 'Applications'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZINN_C_APPLICATIONS as projection on ZINN_I_APPLICATIONS {
 //   @ObjectModel.text.element: ['Applicationdesc']
    key applicationid,
    applicationname,
    
    @Semantics.largeObject: { 
    mimeType: 'mimetype',
    fileName: 'filename',
    contentDispositionPreference: #INLINE
    }
    applicationguide,
    mimetype,
    filename,
 //   Applicationdesc,
    createdby,
    createdat,
    lastchangedby,
    lastchangedat,
    /* Associations */
   // _applicationstext
   _installations : redirected to composition child ZINN_C_INSTALLATIONS,
   
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZINN_CL_INSTALLATIONS_ACTIVES'
    @EndUserText.label: 'Actives Installations'
    virtual Installationsactives : abap.int4
}
