@EndUserText.label: 'Installations'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZINN_C_INSTALLATIONS as projection on ZINN_I_INSTALLATIONS {
    key Applicationid,
    @ObjectModel.text.element: ['Customername']    
    key Customerid,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_ENVIRONMENT' , element: 'value_low'},
     distinctValues: true
    }]
    key Environment,    
    Customername,    
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_INSTALLATIONTYPE' , element: 'value_low'},
     distinctValues: true
    }]
    Installationtype,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_INSTALLATIONSTATUS' , element: 'value_low'},
     distinctValues: true
    }]
    Installationstatus,
    Installationstart,
    Installationend,
    Installationurl,
    Serviceurl,
    Traininghours,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,   
    /* Associations */
    _applications :  redirected to  parent ZINN_C_APPLICATIONS,
    _customers,
    Criticality
       
}
