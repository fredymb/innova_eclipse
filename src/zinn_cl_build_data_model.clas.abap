CLASS zinn_cl_build_data_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZINN_CL_BUILD_DATA_MODEL IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

try.
DELETE from zinn_application.
DELETE from zinn_apptext.
DELETE FROM zinn_appdraft.
DELETE from zinn_customers.
DELETE FROM zinn_installs.
DELETE FROM zinn_instdraft.

get TIME STAMP FIELD data(lv_timestampl).

INSERT zinn_application FROM TABLE @( value #(  ( APPLICATIONID = 'SILI' applicationname = 'Intelligent Releases' createdby = sy-uname createdat = lv_timestampl
                                                  lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                                ( APPLICATIONID = 'SIMP' applicationname = 'Planning Monitor' createdby = sy-uname createdat = lv_timestampl
                                                  lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                                ( APPLICATIONID = 'SIMA' applicationname = 'Warehouse Monitor' createdby = sy-uname createdat = lv_timestampl
                                                  lastchangedby = sy-uname lastchangedat = lv_timestampl )
 ) ).

 INSERT zinn_apptext FROM TABLE @( value #(  ( APPLICATIONID = 'SILI' spras = 'E' APPLICATIONDESC = 'Intelligent Releases' )
                                             ( APPLICATIONID = 'SILI' spras = 'S' APPLICATIONDESC = 'Liberaciones Inteligentes' )
                                             ( APPLICATIONID = 'SIMP' SPRAS = 'E' APPLICATIONDESC = 'Planning Monitor')
                                             ( APPLICATIONID = 'SIMP' SPRAS = 'S' APPLICATIONDESC = 'Monitor de Planificación')
                                             ( APPLICATIONID = 'SIMA' SPRAS = 'E' APPLICATIONDESC =  'Warehouse Monitor')
                                             ( APPLICATIONID = 'SIMA' SPRAS = 'S' APPLICATIONDESC =  'Monitor de Almacén')
 ) ).

 INSERT zinn_customers FROM TABLE @( value #( ( CUSTOMERID = '001' CUSTOMERNAME = 'Arbomex' )
                                              ( CUSTOMERID = '002' CUSTOMERNAME = 'Farma' )
                                              ( CUSTOMERID = '003' CUSTOMERNAME = 'Enaex' )

 ) ).

 INSERT zinn_installs FROM TABLE @( value #( ( APPLICATIONID = 'SILI' CUSTOMERID = '001' ENVIRONMENT = 'DEV' INSTALLATIONTYPE = 'FIORI'
                                               INSTALLATIONSTATUS = 'A' INSTALLATIONSTART = '20230101' INSTALLATIONEND = '20231201'
                                               CREATEDBY = SY-UNAME CREATEDAT = lv_timestampl LASTCHANGEDBY = SY-UNAME LASTCHANGEDAT = lv_timestampl )
                                             ( APPLICATIONID = 'SILI' CUSTOMERID = '002' ENVIRONMENT = 'DEV' INSTALLATIONTYPE = 'FIORI'
                                               INSTALLATIONSTATUS = 'A' INSTALLATIONSTART = '20230101' INSTALLATIONEND = '20231201'
                                               CREATEDBY = SY-UNAME CREATEDAT = lv_timestampl LASTCHANGEDBY = SY-UNAME LASTCHANGEDAT = lv_timestampl )
                                             ( APPLICATIONID = 'SILI' CUSTOMERID = '003' ENVIRONMENT = 'DEV' INSTALLATIONTYPE = 'ONPREM'
                                               INSTALLATIONSTATUS = 'A' INSTALLATIONSTART = '20230101' INSTALLATIONEND = '20231201'
                                               CREATEDBY = SY-UNAME CREATEDAT = lv_timestampl LASTCHANGEDBY = SY-UNAME LASTCHANGEDAT = lv_timestampl )

 ) ).

COMMIT WORK AND WAIT.

out->write( 'DONE!' ).

*call function 'ZINN_F_CALL_ODATA_INITIALIZE'.

catch cx_root.

out->write( 'ERROR!' ).

endtry.

ENDMETHOD.
ENDCLASS.
