create or replace package body util_xmldom_helper
is

    g_doc dbms_xmldom.DOMdocument;

    procedure newDoc(p_root_tag in varchar2, p_root_node out dbms_xmldom.DOMnode)
    is
        nDoc dbms_xmldom.DOMnode;
        e dbms_xmldom.DOMelement;
    begin
        --???check if g_doc already exists and if so free it before creating a new document
        --cannot do not null test on g_doc
        
        g_doc := dbms_xmldom.newDOMdocument;
        nDoc := dbms_xmldom.makenode(doc => g_doc);
        addNode(p_parent => nDoc, p_tag => p_root_tag, p_node => p_root_node);
    end newDoc;

    procedure newDocFromXML(p_xml in xmltype, p_root_node out dbms_xmldom.DOMnode)
    is
        eRoot dbms_xmldom.DOMelement;
    begin
        g_doc := dbms_xmldom.newDOMdocument(p_xml);
        eRoot := dbms_xmldom.getDocumentElement(g_doc);
        p_root_node := dbms_xmldom.makeNode(elem => eRoot);
    end newDocFromXML;

    procedure addDeclaration(p_version in varchar2 default '1.0', p_charset in varchar2 default 'UTF-8')
    is
    begin
        dbms_xmldom.setVersion(g_doc, p_version);
        dbms_xmldom.setCharset(g_doc, p_charset);
    end addDeclaration;
    
/*    procedure setDoc(doc in out nocopy dbms_xmldom.DOMdocument)
    is
    begin
        g_doc := doc;
    end setDoc;
*/

    procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode)
    is
        e dbms_xmldom.DOMelement;
        nc dbms_xmldom.DOMnode;
    begin
        e := dbms_xmldom.createElement(doc => g_doc, tagName => p_tag);
        p_node := dbms_xmldom.makeNode(elem => e);
        nc := dbms_xmldom.appendChild(n => p_parent, newChild => p_node);
    end addNode;

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_node out dbms_xmldom.DOMnode)
    is
        t dbms_xmldom.DOMtext;
        nt dbms_xmldom.DOMnode;
        nc dbms_xmldom.DOMnode;
    begin
        addNode(p_parent => p_parent, p_tag => p_tag, p_node => p_node);
        t := dbms_xmldom.createTextNode(doc => g_doc, data => p_data);
        nt := dbms_xmldom.makeNode(t => t);
        nc := dbms_xmldom.appendChild(n => p_node, newChild => nt);
    end addTextNode;

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2)
    is
        n dbms_xmldom.DOMnode;
    begin
        addTextNode(p_parent => p_parent, p_tag => p_tag, p_data => p_data, p_node => n);
    end addTextNode;

    procedure addNodeAttribute(p_node in out nocopy dbms_xmldom.DOMnode, p_name in varchar2, p_value in varchar2)
    is
        a dbms_xmldom.DOMattr;
        na dbms_xmldom.DOMnode;
    begin
        --new doc attr, convert to node, set node value, add node to element node as child
        a := dbms_xmldom.createattribute(doc => g_doc, name => p_name);
        na := dbms_xmldom.makenode(a);
        dbms_xmldom.setnodevalue(n=>na,nodeValue=>p_value);
        na := dbms_xmldom.appendchild(n=>p_node,newchild=>na);
    end addNodeAttribute;

    function docToXMLtype return XMLtype
    is
        l_xml xmltype;
    begin    
        l_xml := dbms_xmldom.getxmltype(g_doc);
        return l_xml;
    end docToXMLtype;

    function docToString return varchar2
    is
        l_xml xmltype;
    begin
        l_xml := docToXMLtype;
        return l_xml.getstringval();
    end docToString;

    function docToClob return clob
    is
        l_xml xmltype;
    begin
        l_xml := docToXMLtype;
        return l_xml.getClobVal();
    end docToClob;

    procedure freeDoc
    is
    begin
        DBMS_XMLDOM.freeDocument(g_doc);
    end freeDoc;

begin
    null;
end util_xmldom_helper;
