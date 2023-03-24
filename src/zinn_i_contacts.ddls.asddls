@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Contacts'
define root view entity ZINN_I_CONTACTS
  as select from zinn_contacts as Contacts
{
  key contactid as ContactID,
  contactname as Contactname,
  contactphone as Contactphone,
  contactaddress as Contactaddress,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locinst_lastchange_date as LocinstLastchangeDate,
  locinst_lastchange_time as LocinstLastchangeTime,
  locinst_lastchange_tstmpl as LocinstLastchangeTstmpl,
  locinst_lastchange_utcl as LocinstLastchangeUtcl,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchange_date as LastchangeDate,
  lastchange_time as LastchangeTime,
  lastchange_tstmpl as LastchangeTstmpl,
  lastchange_utcl as LastchangeUtcl
  
}
