create or replace package util_xmldom_helper
authid current_user
is
    g_doc dbms_xmldom.DOMdocument;
    g_doc_root_node dbms_xmldom.DOMNode;
    g_doc_root_element dbms_xmldom.DOMelement;

    procedure addDeclaration;    

    --procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode, p_element out dbms_xmldom.DOMelement);

    procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode);

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_node out dbms_xmldom.DOMnode);

   -- procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_element out dbms_xmldom.DOMelement);

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2);
/*
    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false);    

    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_node out dbms_xmldom.DOMnode, p_root_element out dbms_xmldom.DOMelement);

    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_node out dbms_xmldom.DOMnode);
*/
    procedure newDoc(p_root_tag in varchar2, p_root_node out dbms_xmldom.DOMnode);

--    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_element out dbms_xmldom.DOMelement);
    /*
    procedure addDocNode(p_tag in varchar2, p_node out dbms_xmldom.DOMnode, p_element out dbms_xmldom.DOMelement);

    procedure addDocNode(p_tag in varchar2, p_node out dbms_xmldom.DOMnode);

    procedure addDocTextNode(p_tag in varchar2, p_data in varchar2, p_element out dbms_xmldom.DOMelement);

    procedure addDocTextNode(p_tag in varchar2, p_data in varchar2);
*/
    --procedure addElementAttribute(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2);

    --procedure addElementAttributeSetValue(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2);

    --procedure addElementAttributeSetNodeValue(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2);

    procedure addNodeAttribute(p_node in out nocopy dbms_xmldom.DOMnode, p_name in varchar2, p_value in varchar2);

    function to_XMLtype return XMLtype;

    function to_string return varchar2;

    function to_clob return clob;

    procedure freeDoc;

end util_xmldom_helper;
