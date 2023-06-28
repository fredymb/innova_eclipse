@EndUserText.label: 'Messages Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZINN_I_MessagesText
  as select from ZINN_MSGSDESC
  association [1..1] to ZINN_I_Messages_S as _MessagesAll on $projection.SingletonID = _MessagesAll.SingletonID
  association to parent ZINN_I_Messages as _Messages on $projection.Messagecode = _Messages.Messagecode
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key MESSAGECODE as Messagecode,
  @Semantics.text: true
  MESSAGEDESC as Messagedesc,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _MessagesAll,
  _Messages,
  _LanguageText
  
}
