CLASS zinn_cl_installations_actives DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES IF_SADL_EXIT_CALC_ELEMENT_READ.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zinn_cl_installations_actives IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

  DATA: lt_original_data TYPE STANDARD TABLE OF zinn_c_applications WITH DEFAULT KEY,
        lt_installs TYPE STANDARD TABLE OF zinn_installs,
        lt_instdraft TYPE STANDARD TABLE OF zinn_instdraft.

  lt_original_data = CORRESPONDING #( it_original_data ).

  Clear lt_installs.
  select applicationid, customerid, environment, installationstatus
  from zinn_installs
  for all entries in @lt_original_data
  WHERE applicationid = @lt_original_data-applicationid
  AND installationstatus = 'A'
  INTO CORRESPONDING FIELDS OF TABLE @lt_installs.

  Clear lt_instdraft.
  select applicationid, customerid, environment, installationstatus
  from zinn_instdraft
  for all entries in @lt_original_data
  WHERE applicationid = @lt_original_data-applicationid
  INTO CORRESPONDING FIELDS OF TABLE @lt_instdraft.

 LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).

 LOOP AT lt_installs ASSIGNING FIELD-SYMBOL(<fs_installs>) WHERE applicationid = <fs_original_data>-applicationid
                                                           AND  installationstatus = 'A'.
  ADD 1 TO <fs_original_data>-installationsactives.
 ENDLOOP.

 ENDLOOP.

   ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

   IF iv_entity = 'ZINN_C_APPLICATIONS'.
      LOOP AT it_requested_calc_elements INTO
      DATA(ls_calc_elements).
        IF ls_calc_elements = 'INSTALLATIONSACTIVES'.
          APPEND 'APPLICATIONID' TO
          et_requested_orig_elements.
        ENDIF.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
