CLASS lhc_Applications DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE Applications.

ENDCLASS.

CLASS lhc_Applications IMPLEMENTATION.

  METHOD augment_create.

  DATA augment_create TYPE TABLE FOR CREATE ZINN_I_APPLICATIONS.

  LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>).

  APPEND VALUE #( %cid      = <fs_entities>-%cid
                  %is_draft = <fs_entities>-%is_draft
                  %key      = <fs_entities>-%key
                  applicationname = |Name of { <fs_entities>-applicationid }|
                  %control-applicationname = if_abap_behv=>mk-on
                 ) TO augment_create.

  MODIFY AUGMENTING ENTITY ZINN_I_APPLICATIONS
  CREATE
  FROM augment_create.

  ENDLOOP.

  ENDMETHOD.

ENDCLASS.
