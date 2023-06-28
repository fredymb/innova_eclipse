@EndUserText.label: 'Maintain Messages Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZINN_C_MessagesText
  as projection on ZINN_I_MessagesText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key Messagecode,
  Messagedesc,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _Messages : redirected to parent ZINN_C_Messages,
  _MessagesAll : redirected to ZINN_C_Messages_S
  
}
