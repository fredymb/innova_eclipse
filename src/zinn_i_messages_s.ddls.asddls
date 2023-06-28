@EndUserText.label: 'Messages Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZINN_I_Messages_S
  as select from I_Language
    left outer join ZINN_MESSAGES on 0 = 0
  composition [0..*] of ZINN_I_Messages as _Messages
{
  key 1 as SingletonID,
  _Messages,
  max( ZINN_MESSAGES.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
