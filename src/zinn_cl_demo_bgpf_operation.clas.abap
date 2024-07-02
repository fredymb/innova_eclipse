CLASS zinn_cl_demo_bgpf_operation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_bgmc_op_single.

    METHODS constructor
      IMPORTING
        iv_data TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_data TYPE string.

    METHODS modify
      RAISING
        cx_bgmc_operation.

    METHODS save.

ENDCLASS.



CLASS ZINN_CL_DEMO_BGPF_OPERATION IMPLEMENTATION.


  METHOD constructor.
    mv_data = iv_data.
  ENDMETHOD.


  METHOD if_bgmc_op_single~execute.
    modify( ).

    cl_abap_tx=>save( ).

    save( ).
  ENDMETHOD.


  METHOD modify.
    IF mv_data IS INITIAL.
*            RAISE EXCEPTION NEW cx_demo_bgpf( textid = cx_demo_bgpf=>initial_input ).
    ENDIF.

    CONDENSE mv_data.
  ENDMETHOD.


  METHOD save.

    MODIFY zinn_demo_bgpf FROM @( VALUE #( data       = mv_data
                      changed_by = sy-uname
                      change_at = sy-datum
                      change_tm = sy-uzeit ) ).
  ENDMETHOD.
ENDCLASS.
