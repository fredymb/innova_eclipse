CLASS LHC_ZINN_I_MESSAGES_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      AUGMENT FOR MODIFY
        IMPORTING
          ENTITIES_CREATE FOR CREATE MessagesAll\_Messages
          ENTITIES_UPDATE FOR UPDATE Messages.
ENDCLASS.

CLASS LHC_ZINN_I_MESSAGES_S IMPLEMENTATION.
  METHOD AUGMENT.
    DATA: text_for_new_entity      TYPE TABLE FOR CREATE ZINN_I_Messages\_MessagesText,
          text_for_existing_entity TYPE TABLE FOR CREATE ZINN_I_Messages\_MessagesText,
          text_update              TYPE TABLE FOR UPDATE ZINN_I_MessagesText.
    DATA: relates_create TYPE abp_behv_relating_tab,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.
    DATA: text_tky_link  TYPE STRUCTURE FOR READ LINK ZINN_I_Messages\_MessagesText,
          text_tky       LIKE text_tky_link-target.

    READ TABLE entities_create INDEX 1 INTO DATA(entity).
    LOOP AT entity-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
      APPEND 1 TO relates_create.
      INSERT VALUE #( %CID_REF = <target>-%CID
                      %IS_DRAFT = <target>-%IS_DRAFT
                        %KEY-Messagecode = <target>-%KEY-Messagecode
                      %TARGET = VALUE #( (
                        %CID = |CREATETEXTCID{ sy-tabix }|
                        %IS_DRAFT = <target>-%IS_DRAFT
                        Langu = sy-langu
                        Messagedesc = <target>-Messagedesc
                        %CONTROL-Langu = if_abap_behv=>mk-on
                        %CONTROL-Messagedesc = <target>-%CONTROL-Messagedesc ) ) )
                   INTO TABLE text_for_new_entity.
    ENDLOOP.
    MODIFY AUGMENTING ENTITIES OF ZINN_I_Messages_S
      ENTITY Messages
        CREATE BY \_MessagesText
        FROM text_for_new_entity
        RELATING TO entities_create BY relates_create.

    IF entities_update IS NOT INITIAL.
      READ ENTITIES OF ZINN_I_Messages_S
        ENTITY Messages BY \_MessagesText
          FROM CORRESPONDING #( entities_update )
          LINK DATA(link).
      LOOP AT entities_update INTO DATA(update) WHERE %CONTROL-Messagedesc = if_abap_behv=>mk-on.
        DATA(tabix) = sy-tabix.
        text_tky = CORRESPONDING #( update-%TKY MAPPING
                                                        Messagecode = Messagecode
                                    ).
        text_tky-Langu = sy-langu.
        IF line_exists( link[ KEY draft source-%TKY  = CORRESPONDING #( update-%TKY )
                                        target-%TKY  = CORRESPONDING #( text_tky ) ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = text_tky
                          %CID_REF = update-%CID_REF
                          Messagedesc = update-Messagedesc
                          %CONTROL = VALUE #( Messagedesc = update-%CONTROL-Messagedesc )
          ) TO text_update.
        ELSEIF line_exists(  text_for_new_entity[ KEY cid %IS_DRAFT = update-%IS_DRAFT
                                                          %CID_REF  = update-%CID_REF ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = text_tky
                          %CID_REF = text_for_new_entity[ %IS_DRAFT = update-%IS_DRAFT
                          %CID_REF = update-%CID_REF ]-%TARGET[ 1 ]-%CID
                          Messagedesc = update-Messagedesc
                          %CONTROL = VALUE #( Messagedesc = update-%CONTROL-Messagedesc )
          ) TO text_update.
        ELSE.
          APPEND tabix TO relates_cba.
          APPEND VALUE #( %TKY = CORRESPONDING #( update-%TKY )
                          %CID_REF = update-%CID_REF
                          %TARGET  = VALUE #( (
                            %CID = |UPDATETEXTCID{ tabix }|
                            Langu = sy-langu
                            %IS_DRAFT = text_tky-%IS_DRAFT
                            Messagedesc = update-Messagedesc
                            %CONTROL-Langu = if_abap_behv=>mk-on
                            %CONTROL-Messagedesc = update-%CONTROL-Messagedesc
                          ) )
          ) TO text_for_existing_entity.
        ENDIF.
      ENDLOOP.
      IF text_update IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZINN_I_Messages_S
          ENTITY MessagesText
            UPDATE FROM text_update
            RELATING TO entities_update BY relates_update.
      ENDIF.
      IF text_for_existing_entity IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZINN_I_Messages_S
          ENTITY Messages
            CREATE BY \_MessagesText
            FROM text_for_existing_entity
            RELATING TO entities_update BY relates_cba.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
