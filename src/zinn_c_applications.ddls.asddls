@EndUserText.label: 'Applications'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZINN_C_APPLICATIONS as projection on ZINN_I_APPLICATIONS {
 //   @ObjectModel.text.element: ['Applicationdesc']
    key applicationid,
    applicationname,
 //   Applicationdesc,
    createdby,
    createdat,
    lastchangedby,
    lastchangedat
    /* Associations */
   // _applicationstext
}
