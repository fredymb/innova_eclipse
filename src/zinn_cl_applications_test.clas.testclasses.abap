*"* use this source file for your ABAP unit test classes
CLASS lcl_applications_test DEFINITION FINAL
                            FOR TESTING
                            DURATION SHORT
                            RISK LEVEL HARMLESS.

PRIVATE SECTION.

CLASS-DATA:  lo_enviro TYPE REF TO if_cds_test_environment,
             lo_td_applications TYPE REF TO if_cds_test_data.

DATA: lo_applications_double TYPE REF TO if_cds_stub.


 CLASS-METHODS: class_setup,
                class_teardown.

 METHODS: setup,
          teardown,
          test_applications FOR TESTING.

ENDCLASS.

 CLASS lcl_applications_test IMPLEMENTATION.

 METHOD class_setup.

   " Call the CREATE method to create the environment
  cl_cds_test_environment=>create(
  EXPORTING
  i_for_entity = 'ZINN_I_APPLICATIONS' " CDS VIEW NAME
  RECEIVING
  r_result = lo_enviro
  ).

 ENDMETHOD.

 METHOD class_teardown.
   lo_enviro->destroy( ).
 ENDMETHOD.

 METHOD setup.

   DATA: lt_test_applications TYPE TABLE OF zinn_application.

   GET TIME STAMP FIELD DATA(lv_timestampl).

   lt_test_applications = VALUE #( ( applicationid = 'SILI' applicationname = 'Intelligent Releases' createdby = sy-uname createdat = lv_timestampl
                                     lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                  ( applicationid = 'SIMP' applicationname = 'Planning Monitor' createdby = sy-uname createdat = lv_timestampl
                                    lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                  ( applicationid = 'SIMA' applicationname = 'Warehouse Monitor' createdby = sy-uname createdat = lv_timestampl
                                    lastchangedby = sy-uname lastchangedat = lv_timestampl ) ).

  lo_td_applications = cl_cds_test_data=>create( i_data = lt_test_applications ).

" the dependent component name
lo_applications_double = lo_enviro->get_double( i_name = 'ZINN_APPLICATION' ).
lo_applications_double->insert( i_test_data = lo_td_applications ).

 ENDMETHOD.

 METHOD teardown.
   lo_enviro->clear_doubles( ).
 ENDMETHOD.

 METHOD test_applications.

 " perform the assert testing – compare the actual with the expected values
 DATA: lt_exp_applications TYPE TABLE OF zinn_application.

  GET TIME STAMP FIELD DATA(lv_timestampl).

   lt_exp_applications =  VALUE #( ( applicationid = 'SILI' applicationname = 'Intelligent Releases' createdby = sy-uname createdat = lv_timestampl
                                     lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                  ( applicationid = 'SIMP' applicationname = 'Planning Monitor' createdby = sy-uname createdat = lv_timestampl
                                    lastchangedby = sy-uname lastchangedat = lv_timestampl )
                                  ( applicationid = 'SIMA' applicationname = 'Warehouse Monitor' createdby = sy-uname createdat = lv_timestampl
                                    lastchangedby = sy-uname lastchangedat = lv_timestampl ) ).

" The selection on the CDS view gives the test double data
SELECT * FROM zinn_i_applications INTO TABLE @DATA(lt_act_applications).

" Assert checks
cl_abap_unit_assert=>assert_equals(
EXPORTING
act = lines( lt_act_applications )
exp = lines( lt_exp_applications )
msg = |No. of lines must be 3| ).


ENDMETHOD.


 ENDCLASS.
