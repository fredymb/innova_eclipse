@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZINN_I_PETS
  as select from ZINN_PETS as Pets
{
  key petname as Petname,
  pettype as Pettype,
  petage as Petage,
  petowner as Petowner,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.user.lastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locinst_lastchange_date as LocinstLastchangeDate,
  locinst_lastchange_time as LocinstLastchangeTime,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locinst_lastchange_tstmpl as LocinstLastchangeTstmpl,
  locinst_lastchange_utcl as LocinstLastchangeUtcl,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchange_date as LastchangeDate,
  lastchange_time as LastchangeTime,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchange_tstmpl as LastchangeTstmpl,
  lastchange_utcl as LastchangeUtcl
  
}
