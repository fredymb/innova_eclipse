@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vehicles'
define root view entity ZINN_I_VEHICLES as select from zinn_vehicles
{
    key vehiclelicense as Vehiclelicense,
    vehiclemodel as Vehiclemodel,
    vehicletype as Vehicletype,
    lastchangedat as Lastchangedat  
}
