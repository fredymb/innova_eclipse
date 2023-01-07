@EndUserText.label: 'Installations'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZINN_C_INSTALLATIONS as projection on ZINN_I_INSTALLATIONS {
    key Applicationid,
    @ObjectModel.text.element: ['Customername']
    key Customerid,
    key Environment,
    Customername,
    Installationtype,
    Installationstatus,
    Installationstart,
    Installationend,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _applications :  redirected to  parent ZINN_C_APPLICATIONS,
    _customers
}
