CLASS lcl_buffer DEFINITION.
PUBLIC SECTION.
  CONSTANTS: created TYPE c LENGTH 1 VALUE 'C',
             updated TYPE c LENGTH 1 VALUE 'U',
             deleted TYPE c LENGTH 1 VALUE 'D'.
  TYPES: BEGIN OF ty_buffer_master.
           INCLUDE TYPE zinn_vehicles AS data.
  TYPES:     flag TYPE c LENGTH 1,
         END OF ty_buffer_master.
  TYPES: tt_master TYPE SORTED TABLE OF ty_buffer_master
  WITH UNIQUE KEY vehiclelicense.
  CLASS-DATA mt_buffer_master TYPE tt_master.
ENDCLASS.

CLASS lhc_ZINN_I_VEHICLES DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zinn_i_vehicles RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zinn_i_vehicles.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zinn_i_vehicles.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zinn_i_vehicles.

    METHODS read FOR READ
      IMPORTING keys FOR READ zinn_i_vehicles RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zinn_i_vehicles.

ENDCLASS.

CLASS lhc_ZINN_I_VEHICLES IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    LOOP AT entities INTO DATA(ls_entities).
      INSERT VALUE #( flag = lcl_buffer=>created
                      data = CORRESPONDING #( ls_entities-%data ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF NOT ls_entities-%cid IS INITIAL.
        INSERT VALUE #( %cid = ls_entities-%cid
                        vehiclelicense = ls_entities-vehiclelicense ) INTO TABLE mapped-zinn_i_vehicles.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    LOOP AT entities INTO DATA(ls_entities).

      GET TIME STAMP FIELD DATA(lv_time_stamp).

      SELECT SINGLE * FROM zinn_vehicles
      WHERE vehiclelicense EQ @ls_entities-%data-vehiclelicense
      INTO @DATA(ls_ddbb).

      ls_entities-%data-Lastchangedat = lv_time_stamp.

      INSERT VALUE #( flag = lcl_buffer=>updated
                      data = VALUE #( vehiclelicense = ls_entities-%data-vehiclelicense
                                      vehiclemodel = COND #(
                                                             WHEN ls_entities-%control-vehiclemodel EQ if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-vehiclemodel
                                                             ELSE ls_ddbb-vehiclemodel )
                                      vehicletype = COND #(
                                                             WHEN ls_entities-%control-vehicletype EQ if_abap_behv=>mk-on
                                                             THEN ls_entities-%data-vehicletype
                                                             ELSE ls_ddbb-vehicletype )

                       ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF NOT ls_entities-vehiclelicense IS INITIAL.
        INSERT VALUE #( %cid = ls_entities-vehiclelicense
                        vehiclelicense = ls_entities-vehiclelicense ) INTO TABLE mapped-zinn_i_vehicles.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_keys).

      INSERT VALUE #( flag = lcl_buffer=>deleted
                      data = VALUE #( vehiclelicense = ls_keys-%key-vehiclelicense ) ) INTO TABLE lcl_buffer=>mt_buffer_master.

      IF NOT ls_keys-vehiclelicense IS INITIAL.
        INSERT VALUE #( %cid = ls_keys-%key-vehiclelicense
                        vehiclelicense = ls_keys-%key-vehiclelicense ) INTO TABLE mapped-zinn_i_vehicles.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINN_I_VEHICLES DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINN_I_VEHICLES IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA: lt_data_created TYPE STANDARD TABLE OF zinn_vehicles,
          lt_data_updated TYPE STANDARD TABLE OF zinn_vehicles,
          lt_data_deleted TYPE STANDARD TABLE OF zinn_vehicles.

    lt_data_created = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>created ) ( <row>-data ) ).

    IF NOT lt_data_created IS INITIAL.
      INSERT zinn_vehicles FROM TABLE @lt_data_created.
    ENDIF.

    lt_data_updated = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>updated ) ( <row>-data ) ).

    IF NOT lt_data_updated IS INITIAL.
      UPDATE zinn_vehicles FROM TABLE @lt_data_updated.
    ENDIF.

    lt_data_deleted = VALUE #( FOR <row> IN lcl_buffer=>mt_buffer_master
                               WHERE ( flag = lcl_buffer=>deleted ) ( <row>-data ) ).

    IF NOT lt_data_deleted IS INITIAL.
      DELETE zinn_vehicles FROM TABLE @lt_data_deleted.
    ENDIF.

    CLEAR lcl_buffer=>mt_buffer_master.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
