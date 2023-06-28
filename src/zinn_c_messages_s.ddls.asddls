@EndUserText.label: 'Maintain Messages Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZINN_C_Messages_S
  provider contract transactional_query
  as projection on ZINN_I_Messages_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _Messages : redirected to composition child ZINN_C_Messages
  
}
