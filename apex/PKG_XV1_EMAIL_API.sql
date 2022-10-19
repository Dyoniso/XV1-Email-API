create or replace package PKG_XV1_EMAIL_API as

    procedure SEND_EMAIL(l_receiver varchar2, l_subject varchar2, l_text varchar2, l_html varchar2);

end;

create or replace package body PKG_XV1_EMAIL_API as
    l_endpoint varchar2(200) := 'localhost';
    l_port number := 8081;
    l_send_path varchar2(30) := '/mail/send';

    function GET_URL return varchar2 as
    begin
        return l_endpoint || ':' || l_port;
    end;

    function GET_SEND_URL return varchar2 as
    begin
        return GET_URL || l_send_path;
    end;

    procedure SEND_EMAIL(l_receiver varchar2, l_subject varchar2, l_text varchar2, l_html varchar2) 
    is
        v_res clob;
        v_json clob;
    begin
        apex_json.open_object;
        apex_json.write('receiver', l_receiver);
        apex_json.write('subject', l_subject);
        apex_json.write('text', l_text);
        apex_json.write('html', l_html);
        apex_json.close_object;

        v_json := apex_json.get_clob_output;
        apex_json.free_output;

        v_res := apex_web_service.make_rest_request(
           p_url               => GET_SEND_URL,
           p_http_method       => 'POST',
           p_body              => v_json
        );

        DBMS_OUTPUT.PUT_LINE('[Email-Request] ' || to_char(v_res));
    end;
end;
      