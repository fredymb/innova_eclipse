@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Installations'
define view entity ZINN_I_INSTALLATIONS as select from zinn_installs
association to parent ZINN_I_APPLICATIONS as _applications
on $projection.Applicationid = _applications.applicationid
association [0..1] to ZINN_I_CUSTOMERS as _customers 
on $projection.Customerid = _customers.Customerid
     {
    key applicationid as Applicationid,
    @ObjectModel.text.element: ['Customername']
    key customerid as Customerid,
    key environment as Environment,
    _customers.Customername as Customername,
    installationtype as Installationtype,
    installationstatus as Installationstatus,
    installationstart as Installationstart,
    installationend as Installationend,
    @Semantics.user.createdBy: true
    createdby as Createdby,
     @Semantics.systemDateTime.createdAt: true
    createdat as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat,
    _applications, // Make association public
    _customers,
    case installationstatus
    when ''  then 0  
    when 'I' then 1  
    when 'S' then 2     
    when 'A' then 3
    else 0
    end as Criticality
}
