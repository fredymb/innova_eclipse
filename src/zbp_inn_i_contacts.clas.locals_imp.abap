CLASS lsc_zinn_i_contacts DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zinn_i_contacts IMPLEMENTATION.

  METHOD save_modified.

    RAISE ENTITY EVENT zinn_i_contacts~defaultcreated
    FROM VALUE #( FOR <fs_create_contacts> IN create-contacts ( contactid = <fs_create_contacts>-contactid
                                                                %param = VALUE #( comments = 'Comments' ) ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_contacts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS: get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR Contacts
      RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Contacts,
      defaultaddress FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Contacts~defaultaddress,
      Createdefault FOR MODIFY
        IMPORTING keys FOR ACTION Contacts~Createdefault,
      ValidateContactname FOR VALIDATE ON SAVE
        IMPORTING keys FOR Contacts~ValidateContactname.

ENDCLASS.

CLASS lhc_contacts IMPLEMENTATION.
  METHOD get_global_authorizations.
    result-%action-edit = if_abap_behv=>auth-allowed.
    result-%action-Createdefault  = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD earlynumbering_create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      TRY.
          INSERT VALUE #( %cid            = <ls_entity>-%cid
                          %key            = <ls_entity>-%key
                          %is_draft       = <ls_entity>-%is_draft
                          contactid  =  COND #( WHEN <ls_entity>-contactid IS INITIAL
                                                THEN cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                                                ELSE <ls_entity>-contactid )
                           ) INTO TABLE mapped-contacts.

        CATCH cx_uuid_error.
          "handle exception
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

  METHOD defaultaddress.

    READ ENTITIES OF zinn_i_contacts
      ENTITY Contacts
      FIELDS ( contactphone contactaddress )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_contacts).

    LOOP AT lt_contacts ASSIGNING FIELD-SYMBOL(<fs_contacts>).
      SHIFT <fs_contacts>-Contactphone LEFT DELETING LEADING '0'.
      MODIFY ENTITIES OF zinn_i_contacts IN LOCAL MODE
      ENTITY contacts
      UPDATE FIELDS ( contactaddress )
      WITH VALUE #( ( %key = <fs_contacts>-%key
                      %tky = <fs_contacts>-%tky
                      %pky = <fs_contacts>-%pky
                      %is_draft = <fs_contacts>-%is_draft
                      contactaddress = |street {  <fs_contacts>-contactphone }|
                      %control-contactaddress = if_abap_behv=>mk-on ) ) REPORTED DATA(reportedmodify).
    ENDLOOP.

  ENDMETHOD.

  METHOD Createdefault.

    DATA lv_contactid TYPE zinn_e_contactid.

    lv_contactid =  cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( ).

    MODIFY ENTITIES OF zinn_i_contacts
        ENTITY Contacts
        CREATE FROM VALUE #( FOR <instance> IN keys (
                             %cid = <instance>-%cid
                             %is_draft = <instance>-%param-%is_draft
                             contactid  = lv_contactid
                             contactname = 'Contact Name'
                             contactphone = '1234567890'
                             contactaddress = 'Contact Address'
                             %control = VALUE #( contactid = if_abap_behv=>mk-on
                                                 contactname = if_abap_behv=>mk-on
                                                 contactphone = if_abap_behv=>mk-on
                                                 contactaddress = if_abap_behv=>mk-on )
                             ) )
                             MAPPED mapped
                             FAILED failed
                             REPORTED reported.

  ENDMETHOD.


  METHOD ValidateContactname.

    READ ENTITY zinn_i_contacts\\contacts
           FIELDS ( contactname )
           WITH CORRESPONDING #( keys )
           RESULT DATA(lt_contacts).

    LOOP AT lt_contacts ASSIGNING FIELD-SYMBOL(<fs_contacts>).

    "Initialize State Area
    reported-contacts = VALUE #( ( %key = <fs_contacts>-%key
                                   %is_draft = <fs_contacts>-%is_draft
                                   %tky = <fs_contacts>-%tky
                                   %state_area = 'VALIDATE_CONTACTNAME' ) ).

      IF <fs_contacts>-contactname IS INITIAL.

        APPEND VALUE #( %key = <fs_contacts>-%key
                        %is_draft = <fs_contacts>-%is_draft
                        %tky = <fs_contacts>-%tky
                        contactid = <fs_contacts>-contactid ) TO failed-contacts.

        " Contact name is required
        APPEND VALUE #( %key = <fs_contacts>-%key
                        %is_draft = <fs_contacts>-%is_draft
                        %tky = <fs_contacts>-%tky
                        %state_area = 'VALIDATE_CONTACTNAME'
        %msg = new_message( id = 'ZINNOVA'
                            number = '008'
                           severity = if_abap_behv_message=>severity-error )
        %element-contactname = if_abap_behv=>mk-on ) TO reported-contacts.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
