CLASS lhc_contacts DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ZZvalidateContactCourses FOR VALIDATE ON SAVE
      IMPORTING keys FOR Contacts~ZZvalidateContactCourses.

ENDCLASS.

CLASS lhc_contacts IMPLEMENTATION.

  METHOD ZZvalidateContactCourses.

        READ ENTITY zinn_i_contacts\\contacts
        FIELDS ( contactcourses )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
        RESULT DATA(lt_contacts).

    LOOP AT lt_contacts ASSIGNING FIELD-SYMBOL(<fs_contacts>).

      IF <fs_contacts>-contactcourses = 0.

        APPEND VALUE #( %key = <fs_contacts>-%key
                        contactid = <fs_contacts>-contactid ) TO failed-contacts.

        " Contact courses must be greater than 0
        APPEND VALUE #( %key = <fs_contacts>-%key
        %msg = new_message( id = 'ZINNOVA'
                            number = '007'
                           severity = if_abap_behv_message=>severity-error )
        %element-contactcourses = if_abap_behv=>mk-on ) TO reported-contacts.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
