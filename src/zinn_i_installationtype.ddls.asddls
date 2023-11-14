@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Read'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZINN_I_INSTALLATIONTYPE 
       as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZINN_D_INSTALLATIONTYPE') {
    @UI.hidden: true  
    key domain_name,
    @UI.hidden: true  
    key value_position,
    @Semantics.language: true
    @UI.hidden: true  
    key language,
    @Search.defaultSearchElement: true   
    value_low,
    @Semantics.text: true
    @Search.defaultSearchElement: true 
    @Search.fuzzinessThreshold: 0.7
    text
}
where language = $session.system_language
