@EndUserText.label: 'Applications'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZINN_C_APPLICATIONS as projection on ZINN_I_APPLICATIONS {
 //   @ObjectModel.text.element: ['Applicationdesc']
    key applicationid,
    @Search.defaultSearchElement: true
    applicationname,    
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    Applicationdesc,    
    @Semantics.largeObject: { 
    mimeType: 'mimetype',
    fileName: 'filename',
    contentDispositionPreference: #INLINE,
    acceptableMimeTypes: ['application/pdf', 'text/plain']    
    }
    applicationguide,
    @Semantics.imageUrl: true
    applicationimage,
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
    @Search.defaultSearchElement: false       
    virtual Installationsactives : abap.int4
}
