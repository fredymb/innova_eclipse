function zinn_f_call_odata_initialize.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BASE_URL) TYPE  STRING OPTIONAL
*"     VALUE(IV_USERNAME) TYPE  STRING OPTIONAL
*"     VALUE(IV_PASSWORD) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(EV_RESPONSE) TYPE  STRING
*"----------------------------------------------------------------------
 iv_base_url = 'http://54.92.201.218:8001'.
 iv_username = ''.
 iv_password = ''.
 data(lv_complete_url) = |{ iv_base_url }/sap/opu/odata/sap/ZSILW_ODATA_SRV/FioriSet(Mandt='100')?$expand=NavPostdata|.

TRY.

DATA(lo_http_destination) =
     cl_http_destination_provider=>create_by_url( lv_complete_url ).

DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

lo_web_http_client->get_http_request( )->set_authorization_basic(
        i_username = iv_username
        i_password = iv_password ).

"adding headers
DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
lo_web_http_request->set_header_fields( VALUE #(
(  name = 'Accept' value = 'application/json' )
(  name = 'Content-Type' value = 'application/json; charset=utf-8' )
(  name = 'X-CSRF-Token' value = 'Fetch' )
 ) ).

 DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>GET ).
 DATA(lt_response_headers) = lo_web_http_response->get_header_fields( ).

 CLEAR: lv_complete_url, lo_http_destination, lo_web_http_client, lo_web_http_request,
        lo_web_http_response.

 lv_complete_url = |{ iv_base_url }/sap/opu/odata/sap/ZSILW_ODATA_SRV/FioriSet?|.

 lo_http_destination =
     cl_http_destination_provider=>create_by_url( lv_complete_url ).

 lo_web_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

lo_web_http_client->get_http_request( )->set_authorization_basic(
        i_username = iv_username
        i_password = iv_password ).

 data lv_cookie type string.
 loop at lt_response_headers assigning FIELD-SYMBOL(<fs_response_headers>) WHERE name = 'set-cookie'.
  if lv_cookie is initial.
  lv_cookie = <fs_response_headers>-value.
  else.
  lv_cookie = |{ lv_cookie };{ <fs_response_headers>-value  }|.
  endif.
 endloop.

READ TABLE lt_response_headers ASSIGNING <fs_response_headers> with key name = 'x-csrf-token'.
if sy-subrc = 0.
lo_web_http_request = lo_web_http_client->get_http_request( ).
lo_web_http_request->set_header_fields( VALUE #(
(  name = 'Accept' value = 'application/json' )
(  name = 'Content-Type' value = 'application/json; charset=utf-8' )
(  name = 'X-CSRF-Token' value = <fs_response_headers>-value )
(  name = 'Cookie' value = lv_cookie )
 ) ).
endif.

lo_web_http_request->set_text('{ "d" : { "Mandt" : "100", "NavPostdata" : { "results" : [ { "Mandt" : "100", "Name" : "IV_FUNCNAME", "Value" : "ZSILW_F_INITIALIZE" } ] } }}').
"set request method and execute request
lo_web_http_response = lo_web_http_client->execute( if_web_http_client=>POST ).
DATA(lv_response) = lo_web_http_response->get_text( ).

CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error INTO data(lo_err).
    "error handling
    DATA(lv_msg) = lo_err->get_longtext( ).
ENDTRY.

"uncomment the following line for console output; prerequisite: code snippet is implementation of if_oo_adt_classrun~main
"out->write( |response:  { lv_response }| ).

ev_response = lv_response.

ENDFUNCTION.
