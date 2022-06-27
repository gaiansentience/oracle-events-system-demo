create or replace package util_xmldom_helper
authid current_user
is
    procedure newDoc(p_root_tag in varchar2, p_root_node out dbms_xmldom.DOMnode);
    
    procedure newDocFromXML(p_xml in xmltype, p_root_node out dbms_xmldom.DOMnode);

    procedure addDeclaration(p_version in varchar2 default '1.0', p_charset in varchar2 default 'UTF-8');
    
    --procedure setDoc(doc in out nocopy dbms_xmldom.DOMdocument);

    procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode);

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_node out dbms_xmldom.DOMnode);

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2);
    
    procedure addNodeAttribute(p_node in out nocopy dbms_xmldom.DOMnode, p_name in varchar2, p_value in varchar2);

    function docToXMLtype return XMLtype;

    function docToString return varchar2;

    function docToClob return clob;

    procedure freeDoc;

end util_xmldom_helper;
