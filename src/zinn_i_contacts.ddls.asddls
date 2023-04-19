@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Contacts'
@Metadata.allowExtensions: true

@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'ZIN',
  allowNewCompositions : true,
  allowNewDatasources: false,
  dataSources: ['Contacts'],
  quota: {
    maximumFields: 250,
    maximumBytes: 2500
  }
}

define root view entity ZINN_I_CONTACTS
  as select from zinn_contacts as Contacts
{
  key contactid as ContactID,
  contactname as Contactname,
  contactphone as Contactphone,
  contactaddress as Contactaddress,
  contactcourses as Contactcourses,
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
