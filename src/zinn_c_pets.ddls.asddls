@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZINN_C_PETS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZINN_I_PETS
{
  key Petname,
  Pettype,
  Petage,
  Petowner,
  CreatedBy,
  ChangedBy,
  LocinstLastchangeDate,
  LocinstLastchangeTime,
  LocinstLastchangeTstmpl,
  LocinstLastchangeUtcl,
  LastchangeDate,
  LastchangeTime,
  LastchangeTstmpl,
  LastchangeUtcl
  
}
