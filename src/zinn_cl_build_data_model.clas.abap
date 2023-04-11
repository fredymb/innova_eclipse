CLASS zinn_cl_build_data_model DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zinn_cl_build_data_model IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        DELETE FROM zinn_application.
        DELETE FROM zinn_apptext.
        DELETE FROM zinn_appdraft.
        DELETE FROM zinn_customers.
        DELETE FROM zinn_installs.
        DELETE FROM zinn_instdraft.
        DELETE FROM zinn_contacts.
        DELETE FROM zinn_contdraft.

        GET TIME STAMP FIELD DATA(lv_timestampl).

        INSERT zinn_application FROM TABLE @( VALUE #(  ( applicationid = 'SILI' applicationname = 'Intelligent Releases' createdby = sy-uname createdat = lv_timestampl
                                                          lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                          applicationimage = 'https://www.innovainternacional.biz/static/f5843731c15bf0f6e336eab3ca8ab622/0dab9/SiLI_Slide_1_Home.webp' )
                                                        ( applicationid = 'SIMP' applicationname = 'Planning Monitor' createdby = sy-uname createdat = lv_timestampl
                                                          lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                          applicationimage = 'https://www.innovainternacional.biz/static/a931683ac348f282ed052dbaab1a1b40/a66aa/1_SiMPL_Home.webp' )
                                                        ( applicationid = 'SIMA' applicationname = 'Warehouse Monitor' createdby = sy-uname createdat = lv_timestampl
                                                          lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                          applicationimage = 'https://www.innovainternacional.biz/static/3008c6e5c73504c58ff62c7c4a11aa61/a6c4b/1_SiMA_Login.webp' )
         ) ).

        INSERT zinn_apptext FROM TABLE @( VALUE #(  ( applicationid = 'SILI' spras = 'E' applicationdesc = 'Intelligent Releases' )
                                                    ( applicationid = 'SILI' spras = 'S' applicationdesc = 'Liberaciones Inteligentes' )
                                                    ( applicationid = 'SIMP' spras = 'E' applicationdesc = 'Planning Monitor')
                                                    ( applicationid = 'SIMP' spras = 'S' applicationdesc = 'Monitor de Planificación')
                                                    ( applicationid = 'SIMA' spras = 'E' applicationdesc =  'Warehouse Monitor')
                                                    ( applicationid = 'SIMA' spras = 'S' applicationdesc =  'Monitor de Almacén')
        ) ).

        INSERT zinn_customers FROM TABLE @( VALUE #( ( customerid = '001' customername = 'Arbomex' )
                                                     ( customerid = '002' customername = 'Farma' )
                                                     ( customerid = '003' customername = 'Enaex' )

        ) ).

        INSERT zinn_installs FROM TABLE @( VALUE #( ( applicationid = 'SILI' customerid = '001' environment = 'DEV' installationtype = 'FIORI'
                                                      installationstatus = 'A' installationstart = '20230101' installationend = '20231201'
                                                      createdby = sy-uname createdat = lv_timestampl lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                      traininghours = 10 serviceurl = 'http://54.92.201.218:8001/sap/opu/odata/SIAPP/X_ODATA_SRV/' )
                                                    ( applicationid = 'SILI' customerid = '002' environment = 'DEV' installationtype = 'FIORI'
                                                      installationstatus = 'A' installationstart = '20230101' installationend = '20231201'
                                                      createdby = sy-uname createdat = lv_timestampl lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                      traininghours = 20 serviceurl = 'http://54.92.201.218:8001/sap/opu/odata/SIAPP/X_ODATA_SRV/' )
                                                    ( applicationid = 'SILI' customerid = '003' environment = 'DEV' installationtype = 'ONPREM'
                                                      installationstatus = 'A' installationstart = '20230101' installationend = '20231201'
                                                      createdby = sy-uname createdat = lv_timestampl lastchangedby = sy-uname lastchangedat = lv_timestampl
                                                      traininghours = 30 serviceurl = 'http://54.92.201.218:8001/sap/opu/odata/SIAPP/X_ODATA_SRV/' )

        ) ).

        INSERT zinn_contacts FROM TABLE @( VALUE #( ( contactid = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                                                      contactname  = 'John'
                                                      contactphone = '300456789'
                                                      contactaddress = 'Street 789'
                                                      contactcourses = 10
                                                      locinst_lastchange_date = lv_timestampl
                                                      locinst_lastchange_time = sy-uzeit
                                                      locinst_lastchange_tstmpl = lv_timestampl
                                                      lastchange_date = lv_timestampl
                                                      lastchange_time  = sy-uzeit
                                                      lastchange_tstmpl = lv_timestampl )
                                                     ( contactid = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                                                      contactname  = 'Maria'
                                                      contactphone = '3004567123'
                                                      contactaddress = 'Street 123'
                                                      contactcourses = 20
                                                      locinst_lastchange_date = lv_timestampl
                                                      locinst_lastchange_time = sy-uzeit
                                                      locinst_lastchange_tstmpl = lv_timestampl
                                                      lastchange_date = lv_timestampl
                                                      lastchange_time  = sy-uzeit
                                                      lastchange_tstmpl = lv_timestampl )
                                                    ( contactid = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                                                      contactname  = 'Etan'
                                                      contactphone = '3004567090'
                                                      contactaddress = 'Street 090'
                                                      contactcourses = 30
                                                      locinst_lastchange_date = lv_timestampl
                                                      locinst_lastchange_time = sy-uzeit
                                                      locinst_lastchange_tstmpl = lv_timestampl
                                                      lastchange_date = lv_timestampl
                                                      lastchange_time  = sy-uzeit
                                                      lastchange_tstmpl = lv_timestampl )
                                                     ) ).

        COMMIT WORK AND WAIT.

        out->write( 'DONE!' ).

*call function 'ZINN_F_CALL_ODATA_METADATA'.

      CATCH cx_root.

        out->write( 'ERROR!' ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
