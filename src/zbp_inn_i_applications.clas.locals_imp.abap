CLASS lhc_installations DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS defaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Installations~defaultStatus.
    METHODS ActivateInstallation FOR MODIFY
      IMPORTING keys FOR ACTION Installations~ActivateInstallation RESULT result.
    METHODS DeactivateInstallation FOR MODIFY
      IMPORTING keys FOR ACTION Installations~DeactivateInstallation RESULT result.
    METHODS get_features FOR FEATURES IMPORTING keys REQUEST
            requested_features FOR  Installations RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Installations RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Installations RESULT result.
    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Installations~validateDates.
    METHODS defaultUrl FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Installations~defaultUrl.
    METHODS Metadata FOR MODIFY
      IMPORTING keys FOR ACTION Installations~Metadata RESULT result.
    METHODS Copyinstallation FOR MODIFY
      IMPORTING keys FOR ACTION Installations~Copyinstallation.

ENDCLASS.

CLASS lhc_installations IMPLEMENTATION.

  METHOD defaultStatus.

    DATA lv_installationend TYPE zinn_e_installationend.

    READ ENTITIES OF zinn_i_applications
      ENTITY Installations
      FIELDS ( installationstatus installationstart installationend )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_installations).

    lv_installationend = cl_abap_context_info=>get_system_date( ) + 365.

    LOOP AT lt_installations ASSIGNING FIELD-SYMBOL(<fs_installations>) WHERE installationstatus IS INITIAL.
      MODIFY ENTITIES OF zinn_i_applications IN LOCAL MODE
      ENTITY Installations
      UPDATE FIELDS ( installationstatus )
      WITH VALUE #( ( %key = <fs_installations>-%key
                      %tky = <fs_installations>-%tky
                      %pky = <fs_installations>-%pky
                      installationstatus = 'A'
                      installationstart = cl_abap_context_info=>get_system_date( )
                      installationend = lv_installationend
                      %control-installationstatus = if_abap_behv=>mk-on
                      %control-installationstart = if_abap_behv=>mk-on
                      %control-installationend = if_abap_behv=>mk-on  ) ) REPORTED DATA(reportedmodify).
    ENDLOOP.


  ENDMETHOD.

  METHOD ActivateInstallation.

    MODIFY ENTITIES OF zinn_i_applications IN LOCAL MODE
       ENTITY Installations
       UPDATE FIELDS ( installationstatus )
       WITH VALUE #( FOR key_row IN keys ( applicationid = key_row-applicationid
                                           customerid = key_row-customerid
                                           environment = key_row-environment
                                           installationstatus  = 'A' ) ) " Active
       FAILED failed
       REPORTED reported.

    READ ENTITIES OF zinn_i_applications IN LOCAL MODE
    ENTITY Installations
    ALL FIELDS WITH VALUE #( FOR key_row IN keys ( applicationid = key_row-applicationid
                                                   customerid = key_row-customerid
                                                   environment = key_row-environment ) )
    RESULT DATA(lt_installations).

    result = VALUE #( FOR ls_installations IN lt_installations ( applicationid = ls_installations-applicationid
                                                                 customerid = ls_installations-customerid
                                                                 environment = ls_installations-environment
                                                   %param = ls_installations ) ).

    LOOP AT lt_installations ASSIGNING FIELD-SYMBOL(<ls_installations>).
      DATA(lv_installation) = |{ <ls_installations>-customername } - { <ls_installations>-environment }|.
      APPEND VALUE #( applicationid = <ls_installations>-applicationid
      %msg = new_message( id = 'ZINNOVA'
             number = '001'
             v1 = lv_installation
            severity = if_abap_behv_message=>severity-success )
       ) TO reported-installations.
    ENDLOOP.

  ENDMETHOD.

  METHOD DeactivateInstallation.

    MODIFY ENTITIES OF zinn_i_applications IN LOCAL MODE
      ENTITY Installations
      UPDATE FIELDS ( installationstatus )
      WITH VALUE #( FOR key_row IN keys ( applicationid = key_row-applicationid
                                          customerid = key_row-customerid
                                          environment = key_row-environment
                                          installationstatus  = 'I' ) ) " Inactive
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zinn_i_applications IN LOCAL MODE
    ENTITY Installations
    ALL FIELDS WITH VALUE #( FOR key_row IN keys ( applicationid = key_row-applicationid
                                                   customerid = key_row-customerid
                                                   environment = key_row-environment ) )
    RESULT DATA(lt_installations).

    result = VALUE #( FOR ls_installations IN lt_installations ( applicationid = ls_installations-applicationid
                                                                 customerid = ls_installations-customerid
                                                                 environment = ls_installations-environment
                                                   %param = ls_installations ) ).

    LOOP AT lt_installations ASSIGNING FIELD-SYMBOL(<ls_installations>).
      DATA(lv_installation) = |{ <ls_installations>-customername } - { <ls_installations>-environment }|.
      APPEND VALUE #( applicationid = <ls_installations>-applicationid
      %msg = new_message( id = 'ZINNOVA'
             number = '002'
             v1 = lv_installation
            severity = if_abap_behv_message=>severity-success )
       ) TO reported-installations.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zinn_i_applications
      ENTITY Installations
      FIELDS ( applicationid customerid environment installationstatus )
      WITH VALUE #( FOR key_row IN keys ( %key = key_row-%key ) )
      RESULT DATA(lt_installations).

    result = VALUE #( FOR ls_installations IN lt_installations (
                            %key = ls_installations-%key
                            %pky = ls_installations-%pky
                            %tky = ls_installations-%tky
                            %is_draft = ls_installations-%is_draft
                            %action-ActivateInstallation = COND #( WHEN
                            ls_installations-installationstatus = 'A'
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )
                            %action-DeactivateInstallation = COND #( WHEN
                            ls_installations-installationstatus = 'I'
                            THEN if_abap_behv=>fc-o-disabled
                            ELSE if_abap_behv=>fc-o-enabled )
                            %action-Metadata = if_abap_behv=>fc-o-enabled
                            %action-Copyinstallation = if_abap_behv=>fc-o-enabled ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      <ls_result> = VALUE #( %key = <ls_keys>-%key
                             %action-ActivateInstallation = if_abap_behv=>auth-allowed
                             %action-DeactivateInstallation = if_abap_behv=>auth-allowed
                             %action-Metadata = if_abap_behv=>auth-allowed
                             %action-Copyinstallation = if_abap_behv=>auth-allowed
                            ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    result-%action-ActivateInstallation = if_abap_behv=>auth-allowed.
    result-%action-DeactivateInstallation = if_abap_behv=>auth-allowed.
    result-%action-Metadata = if_abap_behv=>auth-allowed.
    result-%action-Copyinstallation = if_abap_behv=>auth-allowed.

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITY zinn_i_applications\\Installations
      FIELDS ( installationstart installationend )
      WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
      RESULT DATA(lt_installations).

    LOOP AT lt_installations ASSIGNING FIELD-SYMBOL(<fs_installations>).

      IF <fs_installations>-installationend LT <fs_installations>-installationstart.

        APPEND VALUE #( %key = <fs_installations>-%key
                        applicationid = <fs_installations>-applicationid
                        customerid = <fs_installations>-customerid
                        environment = <fs_installations>-environment ) TO failed-installations.

        APPEND VALUE #( %key = <fs_installations>-%key
        %msg = new_message( id = 'ZINNOVA'
                            number = '003'
                            v1 = <fs_installations>-installationstart
                            v2 = <fs_installations>-installationend
                            v3 = |{ <fs_installations>-customername } '-' { <fs_installations>-environment }|
                           severity = if_abap_behv_message=>severity-error )
        %element-installationstart = if_abap_behv=>mk-on
        %element-installationend =  if_abap_behv=>mk-on ) TO reported-installations.

*      ELSEIF <fs_installations>-installationstart < cl_abap_context_info=>get_system_date( ). "Installation Start must be in the future
*
*        APPEND VALUE #( %key = <fs_installations>-%key
*                        applicationid = <fs_installations>-applicationid
*                        customerid = <fs_installations>-customerid
*                        environment = <fs_installations>-environment ) TO failed-installations.
*
*        APPEND VALUE #( %key = <fs_installations>-%key
*        %msg = new_message( id = 'ZINNOVA'
*                            number = '004'
*                            v1 = <fs_installations>-installationstart
*                            v2 = <fs_installations>-installationend
*                            v3 = |{ <fs_installations>-customername } '-' { <fs_installations>-environment }|
*                           severity = if_abap_behv_message=>severity-error )
*        %element-installationstart = if_abap_behv=>mk-on
*        %element-installationend =  if_abap_behv=>mk-on ) TO reported-installations.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD defaultUrl.

    DATA lv_installationend TYPE zinn_e_installationend.

    READ ENTITIES OF zinn_i_applications
      ENTITY Installations
      FIELDS ( installationtype installationurl )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_installations).

    LOOP AT lt_installations ASSIGNING FIELD-SYMBOL(<fs_installations>) WHERE installationtype IS NOT INITIAL.
      MODIFY ENTITIES OF zinn_i_applications IN LOCAL MODE
      ENTITY Installations
      UPDATE FIELDS ( installationurl )
      WITH VALUE #( ( %key = <fs_installations>-%key
                      %tky = <fs_installations>-%tky
                      %pky = <fs_installations>-%pky
                      installationurl = SWITCH #( <fs_installations>-installationtype
                                                   WHEN 'FIORI' THEN '/sap/opu/odata/'
                                                   WHEN 'ONPREM' THEN '/sap/bc/srt/wsdl/'
                                                   WHEN 'SAaS' THEN '/sap/bc/srt/wsdl/' )
                      %control-installationurl = if_abap_behv=>mk-on ) ) REPORTED DATA(reportedmodify).
    ENDLOOP.


  ENDMETHOD.

  METHOD Metadata.

    DATA: lv_response TYPE string,
          lv_error    TYPE string.

    DATA(lt_keys) = keys.

    READ ENTITIES OF zinn_i_applications IN LOCAL MODE
     ENTITY Installations
     ALL FIELDS WITH VALUE #( FOR key_row IN keys ( applicationid = key_row-applicationid
                                                    customerid = key_row-customerid
                                                    environment = key_row-environment ) )
     RESULT DATA(lt_installations).



    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      READ TABLE lt_installations ASSIGNING FIELD-SYMBOL(<ls_installations>) WITH KEY applicationid = <fs_key>-Applicationid
                                                                                      customerid = <fs_key>-Customerid
                                                                                      environment = <fs_key>-Environment .

      CHECK sy-subrc = 0.

      CLEAR: lv_response, lv_error.
      CALL FUNCTION 'ZINN_F_CALL_ODATA_METADATA'
        EXPORTING
          iv_base_url = <ls_installations>-serviceurl
          iv_username = <fs_key>-%param-username
          iv_password = <fs_key>-%param-password
        IMPORTING
          ev_response = lv_response
          ev_error    = lv_error.



      IF lv_response IS NOT INITIAL.
        cl_message_helper=>set_msg_vars_for_clike( lv_response ).
        APPEND VALUE #( applicationid = <ls_installations>-applicationid
          %msg = new_message( id = 'ZINNOVA'
               number = '006'
               v1 = sy-msgv1
               v2 = sy-msgv2
               v3 = sy-msgv3
               v4 = sy-msgv4
              severity = if_abap_behv_message=>severity-information )
         ) TO reported-installations.
      ENDIF.

      IF lv_error IS NOT INITIAL.
        cl_message_helper=>set_msg_vars_for_clike( lv_error ).
        APPEND VALUE #( applicationid = <ls_installations>-applicationid
          %msg = new_message( id = 'ZINNOVA'
               number = '006'
               v1 = sy-msgv1
               v2 = sy-msgv2
               v3 = sy-msgv3
               v4 = sy-msgv4
              severity = if_abap_behv_message=>severity-information )
         ) TO reported-installations.

        APPEND VALUE #( %key = <fs_key>-%key
                          applicationid = <ls_installations>-applicationid
                          customerid = <ls_installations>-customerid
                          environment = <ls_installations>-environment
                           ) TO failed-installations.
      ENDIF.

    ENDLOOP.

    result = VALUE #( FOR ls_installations IN lt_installations ( applicationid = ls_installations-applicationid
                                                                customerid = ls_installations-customerid
                                                                environment = ls_installations-environment
                                                     %param = ls_installations ) ).


  ENDMETHOD.

  METHOD Copyinstallation.

    DATA: lt_installations TYPE TABLE FOR CREATE zinn_i_applications\_installations,
          lw_installations LIKE LINE OF lt_installations,
          lv_cont(2)       TYPE n.

    " Read selected data from the frontend

    READ ENTITIES OF zinn_i_applications IN LOCAL MODE
      ENTITY Installations
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(installations)
      FAILED failed.

    LOOP AT installations ASSIGNING FIELD-SYMBOL(<fs_installations>).

      APPEND VALUE #(  applicationid = keys[ KEY entity %key = <fs_installations>-%key ]-Applicationid
                       %target = VALUE #( (  %cid = keys[ KEY entity %key = <fs_installations>-%key ]-%cid
                                          %is_draft = keys[ KEY entity %key = <fs_installations>-%key ]-%is_draft
                                          %data = CORRESPONDING #( <fs_installations> ) ) )
                     )

                      TO lt_installations ASSIGNING FIELD-SYMBOL(<fs_newinstallation>).

      CLEAR lv_cont.
      LOOP AT <fs_newinstallation>-%target ASSIGNING FIELD-SYMBOL(<fs_target>).
        ADD 1 TO lv_cont.
        <fs_target>-environment = |{ <fs_target>-environment(1) }{ lv_cont }|.

      ENDLOOP.

      " Create BO instance by copy

      MODIFY ENTITIES OF zinn_i_applications IN LOCAL MODE
      ENTITY applications
      CREATE BY \_installations
      FIELDS ( applicationid customerid environment installationtype  installationstatus installationstart installationend installationurl serviceurl traininghours )
      WITH lt_installations
      MAPPED DATA(mapped_create).

      mapped-installations = mapped_create-installations.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZINN_I_APPLICATIONS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Applications RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
       REQUEST requested_authorizations FOR Applications RESULT result.

    METHODS get_features FOR FEATURES IMPORTING keys REQUEST
     requested_features FOR  Applications RESULT result.
    METHODS aboutapp FOR MODIFY
      IMPORTING keys FOR ACTION applications~aboutapp.

ENDCLASS.

CLASS lhc_ZINN_I_APPLICATIONS IMPLEMENTATION.

  METHOD get_instance_authorizations.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      <ls_result> = VALUE #( %key = <ls_keys>-%key
                             %update = if_abap_behv=>auth-allowed
                             %op-%update = if_abap_behv=>auth-allowed
                             %delete      = if_abap_behv=>auth-allowed
                             %action-edit = if_abap_behv=>auth-allowed
                             %action-aboutapp = if_abap_behv=>auth-allowed
                             ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

*   Check if EDIT operation is triggered or not
    IF requested_authorizations-%create = if_abap_behv=>mk-on OR
        requested_authorizations-%update = if_abap_behv=>mk-on OR
        requested_authorizations-%action-Edit   = if_abap_behv=>mk-on.

*     Check method IS_UPDATE_ALLOWED (Authorization simulation Check method)
*      IF is_update_allowed( ) = abap_true.

*       update result with EDIT Allowed
      result-%create = if_abap_behv=>auth-allowed.
      result-%update = if_abap_behv=>auth-allowed.
      result-%action-Edit = if_abap_behv=>auth-allowed.
      result-%action-aboutapp = if_abap_behv=>auth-allowed.

*      ELSE.

*       update result with EDIT Not Allowed
*        result-%create = if_abap_behv=>auth-unauthorized.
*        result-%update = if_abap_behv=>auth-unauthorized.
*        result-%action-Edit = if_abap_behv=>auth-unauthorized.

*      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zinn_i_applications
      ENTITY Applications
      ALL FIELDS
      WITH VALUE #( FOR key_row IN keys ( %key = key_row-%key ) )
      RESULT DATA(lt_applications).

    result = VALUE #( FOR ls_applications IN lt_applications (
                            %key = ls_applications-%key
                            applicationid = if_abap_behv=>fc-f-read_only
                             ) ).

  ENDMETHOD.

  METHOD aboutapp.

    READ ENTITIES OF zinn_i_applications
        ENTITY applications
        FIELDS ( applicationid )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_applications).

    DATA(ls_applications) = lt_applications[ 1 ].

    APPEND VALUE #( applicationid = ls_applications-applicationid
          %msg = new_message( id = 'ZINNOVA'
                 number = '005'
                 v1 = ls_applications-applicationid
                severity = if_abap_behv_message=>severity-information )
           ) TO reported-applications.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZINN_I_APPLICATIONS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINN_I_APPLICATIONS IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_apptext TYPE STANDARD TABLE OF zinn_apptext,
          lw_apptext TYPE zinn_apptext.

    " Crear texto
    CLEAR lt_apptext.
    LOOP AT create-applications ASSIGNING FIELD-SYMBOL(<fs_create_applications>).
      CLEAR lw_apptext.
      lw_apptext-applicationid = <fs_create_applications>-applicationid.
      lw_apptext-spras = sy-langu.
      lw_apptext-applicationdesc = <fs_create_applications>-applicationdesc.
      APPEND lw_apptext TO lt_apptext.
    ENDLOOP.
    IF lt_apptext IS NOT INITIAL.
      TRY.
          MODIFY zinn_apptext FROM TABLE @lt_apptext.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

    " Modificar texto
    CLEAR lt_apptext.
    LOOP AT update-applications ASSIGNING FIELD-SYMBOL(<fs_update_applications>).
      CLEAR lw_apptext.
      lw_apptext-applicationid = <fs_update_applications>-applicationid.
      lw_apptext-spras = sy-langu.
      lw_apptext-applicationdesc = <fs_update_applications>-applicationdesc.
      APPEND lw_apptext TO lt_apptext.
    ENDLOOP.
    IF lt_apptext IS NOT INITIAL.
      TRY.
          MODIFY zinn_apptext FROM TABLE @lt_apptext.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

    " Eliminar texto
    CLEAR lt_apptext.
    LOOP AT delete-applications ASSIGNING FIELD-SYMBOL(<fs_delete_applications>).
      CLEAR lw_apptext.
      lw_apptext-applicationid = <fs_delete_applications>-applicationid.
      lw_apptext-spras = sy-langu.
      APPEND lw_apptext TO lt_apptext.
    ENDLOOP.
    IF lt_apptext IS NOT INITIAL.
      TRY.
          DELETE zinn_apptext FROM TABLE @lt_apptext.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
