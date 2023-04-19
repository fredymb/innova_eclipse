@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZINN_I_CONTACTS'
@ObjectModel.semanticKey: [ 'ContactID' ]

@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'ZIN',
  allowNewDatasources: false,
  dataSources: ['contacts'],
  quota: {
    maximumFields: 250,
    maximumBytes: 2500
  }
}

define root view entity ZINN_C_CONTACTS
  provider contract transactional_query
  as projection on ZINN_I_CONTACTS as contacts
{
  key ContactID,
  Contactname,
  Contactphone,
  Contactaddress,
  Contactcourses,
  LocinstLastchangeDate,
  LocinstLastchangeTime,
  LocinstLastchangeTstmpl,
  LocinstLastchangeUtcl,
  LastchangeTime,
  LastchangeTstmpl,
  LastchangeUtcl
  
}
