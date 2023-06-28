@EndUserText.label: 'Maintain Messages'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZINN_C_Messages
  as projection on ZINN_I_Messages
{
  key Messagecode,
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _MessagesAll : redirected to parent ZINN_C_Messages_S,
  _MessagesText : redirected to composition child ZINN_C_MessagesText,
  _MessagesText.Messagedesc : localized
  
}
