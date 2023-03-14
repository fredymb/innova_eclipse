function zinn_f_call_odata_metadata.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BASE_URL) TYPE  ZINN_E_SERVICEURL OPTIONAL
*"     VALUE(IV_USERNAME) TYPE  ZINN_E_USERNAME OPTIONAL
*"     VALUE(IV_PASSWORD) TYPE  ZINN_E_PASSWORD OPTIONAL
*"  EXPORTING
*"     VALUE(EV_RESPONSE) TYPE  STRING
*"     VALUE(EV_ERROR) TYPE  STRING
*"----------------------------------------------------------------------
data: lv_base_url type string,
      lv_username type string,
      lv_password type string.

 lv_base_url = iv_base_url.
 lv_username = iv_username.
 lv_password = iv_password.
 data(lv_complete_url) = |{ lv_base_url }$metadata|.

TRY.

DATA(lo_http_destination) =
     cl_http_destination_provider=>create_by_url( lv_complete_url ).

DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

lo_web_http_client->get_http_request( )->set_authorization_basic(
        i_username = lv_username
        i_password = lv_password ).

"adding headers
DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
lo_web_http_request->set_header_fields( VALUE #(
"(  name = 'Accept' value = 'application/json' )
(  name = 'Content-Type' value = 'application/json; charset=utf-8' )
"(  name = 'X-CSRF-Token' value = 'Fetch' )
 ) ).

 DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>GET ).
DATA(lv_response) = lo_web_http_response->get_text( ).

CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error INTO data(lo_err).
    "error handling
    DATA(lv_msg) = lo_err->get_longtext( ).
    ev_error = lv_msg.
ENDTRY.

"uncomment the following line for console output; prerequisite: code snippet is implementation of if_oo_adt_classrun~main
"out->write( |response:  { lv_response }| ).

ev_response = lv_response.

ENDFUNCTION.
