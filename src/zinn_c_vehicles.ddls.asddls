@EndUserText.label: 'Vehicles'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity  ZINN_C_VEHICLES as projection on ZINN_I_VEHICLES
{
    key Vehiclelicense,
    Vehiclemodel,
    Vehicletype,
    Lastchangedat
}
