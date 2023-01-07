@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Applications Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'applicationid'
define view entity ZINN_I_APPLICATIONSTEXT as select from zinn_apptext {
    key applicationid as Applicationid,
    @Semantics . language: true
    key spras as Spras,
    @Semantics.text: true
    applicationdesc as Applicationdesc
}


