@EndUserText.label: 'Messages'
@AccessControl.authorizationCheck: #CHECK
define view entity ZINN_I_Messages
  as select from ZINN_MESSAGES
  association to parent ZINN_I_Messages_S as _MessagesAll on $projection.SingletonID = _MessagesAll.SingletonID
  composition [0..*] of ZINN_I_MessagesText as _MessagesText
{
  key MESSAGECODE as Messagecode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _MessagesAll,
  _MessagesText
  
}
