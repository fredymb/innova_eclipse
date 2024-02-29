@EndUserText.label: 'Installations'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZINN_C_INSTALLATIONS as projection on ZINN_I_INSTALLATIONS {
    key Applicationid,
    @ObjectModel.text.element: ['Customername']  
    @Search.defaultSearchElement: true  
    key Customerid,
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_ENVIRONMENT' , element: 'value_low'},
     distinctValues: true
    }]
    @Search.defaultSearchElement: true
    key Environment,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7   
    Customername,  
    
    @Consumption.valueHelpDefinition: 
      [{ entity: { name : 'ZINN_I_DOMAIN_FIX_VAL' , element: 'low' } ,
         additionalBinding: [{ element: 'domain_name',
                               localConstant: 'ZINN_E_INSTALLATIONTYPE', usage: #FILTER }]
                               , distinctValues: true
                               }]  
//    @Consumption.valueHelpDefinition: [{ entity:
//    {name: 'ZINN_I_INSTALLATIONTYPE' , element: 'value_low'},
//     distinctValues: true
//    }]
    
    @Search.defaultSearchElement: true
    Installationtype,    
    @Consumption.valueHelpDefinition: [{ entity:
    {name: 'ZINN_I_INSTALLATIONSTATUS' , element: 'value_low'},
     distinctValues: true
    }]
    @Search.defaultSearchElement: true
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
