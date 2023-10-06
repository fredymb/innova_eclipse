@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contacts Additional Info'


define root view entity ZINN_I_CONTACTS_ADD
  as select from zinn_contacts as ContactsAdd
{
  key contactid         as ContactID,
      'Additional Info' as AddInfo
}
