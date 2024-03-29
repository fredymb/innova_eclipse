@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vehicle Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINN_I_VEHICLETYPE 
       as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZINN_D_VEHICLETYPE') {
    @UI.hidden: true  
    key domain_name,
    @UI.hidden: true  
    key value_position,
    @Semantics.language: true
    @UI.hidden: true  
    key language,
    value_low,
    @Semantics.text: true
    text
}
where language = $session.system_language
