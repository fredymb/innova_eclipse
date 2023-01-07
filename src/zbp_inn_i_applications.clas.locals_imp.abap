CLASS lhc_ZINN_I_APPLICATIONS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zinn_i_applications RESULT result.

   METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zinn_i_applications RESULT result.

   METHODS get_features FOR FEATURES IMPORTING keys REQUEST
    requested_features FOR  zinn_i_applications RESULT result.

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
    ENTITY zinn_i_applications
    all fields
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
