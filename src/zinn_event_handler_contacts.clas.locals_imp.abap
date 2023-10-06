*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhe_handler DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS defaultcreated FOR ENTITY EVENT defaultcreated FOR zinn_i_contacts~DefaultCreated.
    METHODS zzdefaultcreated FOR ENTITY EVENT ZZDefaultCreated FOR zinn_i_contacts~ZZDefaultCreated.

ENDCLASS.

CLASS lhe_handler IMPLEMENTATION.


  METHOD defaultcreated.

    DATA ls_events TYPE zinn_events.

    GET TIME STAMP FIELD DATA(lv_timestamp).


    LOOP AT defaultcreated ASSIGNING FIELD-SYMBOL(<fs_defaultcreated>).

      CLEAR ls_events.
      ls_events = VALUE #( eventid = 'DEFAULTCREATED'
                                            createdby = sy-uname
                                            createdat = lv_timestamp
                                            comments = <fs_defaultcreated>-%param-comments ).

      CALL FUNCTION 'ZINN_F_UPDATE_EVENTS'
        EXPORTING
          is_events = ls_events.

    ENDLOOP.

  ENDMETHOD.

  METHOD zzdefaultcreated.

    DATA ls_events TYPE zinn_events.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT zzdefaultcreated ASSIGNING FIELD-SYMBOL(<fs_zzdefaultcreated>).

      CLEAR ls_events.
      ls_events = VALUE #( eventid = 'ZZDEFAULTCREATED'
                                            createdby = sy-uname
                                            createdat = lv_timestamp
                                            comments = <fs_zzdefaultcreated>-%param-AddInfo ).

      CALL FUNCTION 'ZINN_F_UPDATE_EVENTS'
        EXPORTING
          is_events = ls_events.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
