@EndUserText.label: 'Metadata'
@Metadata.allowExtensions: true

define abstract entity ZINN_I_METADATA 
{
   @UI.defaultValue : #( 'ELEMENT_OF_REFERENCED_ENTITY: Customername')
   username : zinn_e_username;
   @UI.defaultValue: '12345'
   password : zinn_e_password;
    
}
