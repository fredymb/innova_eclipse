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

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT defaultcreated ASSIGNING FIELD-SYMBOL(<fs_defaultcreated>).
*      MODIFY zinn_events FROM @( VALUE #( eventid = 'DEFAULTCREATED'
*                                          createdby = sy-uname
*                                          createdat = lv_timestamp
*                                          comments = <fs_defaultcreated>-%param-comments ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD zzdefaultcreated.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT zzdefaultcreated ASSIGNING FIELD-SYMBOL(<fs_zzdefaultcreated>).
*      MODIFY zinn_events FROM @( VALUE #( eventid = 'ZZDEFAULTCREATED'
*                                          createdby = sy-uname
*                                          createdat = lv_timestamp
*                                          comments = <fs_zzdefaultcreated>-%param-AddInfo ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
