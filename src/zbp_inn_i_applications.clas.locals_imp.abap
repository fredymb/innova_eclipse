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
                            ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      <ls_result> = VALUE #( %key = <ls_keys>-%key
                             %action-ActivateInstallation = if_abap_behv=>auth-allowed
                             %action-DeactivateInstallation = if_abap_behv=>auth-allowed
                            ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    result-%action-ActivateInstallation = if_abap_behv=>auth-allowed.
    result-%action-DeactivateInstallation = if_abap_behv=>auth-allowed.

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

ENDCLASS.

CLASS lhc_ZINN_I_APPLICATIONS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Applications RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
       REQUEST requested_authorizations FOR Applications RESULT result.

    METHODS get_features FOR FEATURES IMPORTING keys REQUEST
     requested_features FOR  Applications RESULT result.

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

ENDCLASS.

CLASS lsc_ZINN_I_APPLICATIONS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZINN_I_APPLICATIONS IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
