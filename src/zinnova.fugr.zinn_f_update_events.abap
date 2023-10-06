FUNCTION zinn_f_update_events.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_EVENTS) TYPE  ZINN_EVENTS
*"----------------------------------------------------------------------
  cl_abap_tx=>save(  ).

  MODIFY zinn_events FROM @is_events.

ENDFUNCTION.
