@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZINN_I_CONTACTS'
@ObjectModel.semanticKey: [ 'ContactID' ]
define root view entity ZINN_C_CONTACTS
  provider contract transactional_query
  as projection on ZINN_I_CONTACTS
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
