CLASS lhc_contacts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS: get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR Contacts
      RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Contacts.
ENDCLASS.

CLASS lhc_contacts IMPLEMENTATION.
  METHOD get_global_authorizations.
    result-%action-edit = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD earlynumbering_create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      TRY.
          INSERT VALUE #( %cid            = <ls_entity>-%cid
                          %key            = <ls_entity>-%key
                          %is_draft       = <ls_entity>-%is_draft
                          contactid  = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( ) ) INTO TABLE mapped-contacts.

        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
