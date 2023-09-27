*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhe_handler DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
PRIVATE SECTION.
METHODS appcreated FOR ENTITY EVENT appcreated FOR Applications~appcreated.

ENDCLASS.

CLASS lhe_handler IMPLEMENTATION.

  METHOD appcreated.

  GET TIME STAMP FIELD DATA(lv_timestamp).

   LOOP AT appcreated ASSIGNING FIELD-SYMBOL(<fs_appcreated>).
*        MODIFY zinn_events FROM @( VALUE #( eventid = 'APPCREATED'
*                                            createdby = sy-uname
*                                            createdat = lv_timestamp
*                                            comments = '' ) ).
   ENDLOOP.
  ENDMETHOD.

ENDCLASS.
