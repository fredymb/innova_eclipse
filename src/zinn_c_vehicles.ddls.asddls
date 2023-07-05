@EndUserText.label: 'Vehicles'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity  ZINN_C_VEHICLES as projection on ZINN_I_VEHICLES
{
    key Vehiclelicense,
    Vehiclemodel,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_VEHICLETYPE' , element: 'value_low'},
     distinctValues: true
    }]
    Vehicletype,
    Lastchangedat
}
