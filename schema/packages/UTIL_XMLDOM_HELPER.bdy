create or replace package body util_xmldom_helper
is

    procedure addDeclaration
    is
    begin
        --add XML declaration
        dbms_xmldom.setVersion(g_doc, '1.0" encoding="UTF-8');
        dbms_xmldom.setCharset(g_doc,'UTF-8');
    end addDeclaration;

/*
    procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode, p_element out dbms_xmldom.DOMelement)
    is
        nc dbms_xmldom.DOMnode;
    begin
        p_element := dbms_xmldom.createElement(doc => g_doc, tagName => p_tag);
        p_node := dbms_xmldom.makeNode(elem => p_element);
        nc := dbms_xmldom.appendChild(n => p_parent, newChild => p_node);
    end addNode;
*/
    procedure addNode(p_parent in out nocopy dbms_xmldom.DOMnode, p_tag in varchar2, p_node out dbms_xmldom.DOMnode)
    is
        e dbms_xmldom.DOMelement;
        nc dbms_xmldom.DOMnode;
    begin
--        addNode(p_parent => p_parent, p_tag => p_tag, p_node => p_node, p_element => e);
        e := dbms_xmldom.createElement(doc => g_doc, tagName => p_tag);
        p_node := dbms_xmldom.makeNode(elem => e);
        nc := dbms_xmldom.appendChild(n => p_parent, newChild => p_node);
    end addNode;

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_node out dbms_xmldom.DOMnode)
    is
--        n dbms_xmldom.DOMnode;
       -- e dbms_xmldom.DOMelement;
        t dbms_xmldom.DOMtext;
        nt dbms_xmldom.DOMnode;
        nc dbms_xmldom.DOMnode;
    begin

        addNode(p_parent => p_parent, p_tag => p_tag, p_node => p_node);
        t := dbms_xmldom.createTextNode(doc => g_doc, data => p_data);
        nt := dbms_xmldom.makeNode(t => t);
        nc := dbms_xmldom.appendChild(n => p_node, newChild => nt);
    end addTextNode;
/*
    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2, p_element out dbms_xmldom.DOMelement)
    is
        n dbms_xmldom.DOMnode;
        t dbms_xmldom.DOMtext;
        nt dbms_xmldom.DOMnode;
        nc dbms_xmldom.DOMnode;
    begin
        addNode(p_parent => p_parent, p_tag => p_tag, p_node => n, p_element => p_element);
        t := dbms_xmldom.createTextNode(doc => g_doc, data => p_data);
        nt := dbms_xmldom.makeNode(t => t);
        nc := dbms_xmldom.appendChild(n => n, newChild => nt);
    end addTextNode;
*/

    procedure addTextNode(p_parent in out nocopy dbms_xmldom.DOMNode, p_tag in varchar2, p_data in varchar2)
    is
        n dbms_xmldom.DOMnode;
    begin
        addTextNode(p_parent => p_parent, p_tag => p_tag, p_data => p_data, p_node => n);
    end addTextNode;

/*
    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false)
    is
        n dbms_xmldom.DOMnode;
    begin
        g_doc := dbms_xmldom.newDOMdocument;
        if p_add_xml_declaration then
            addDeclaration;
        end if;
        n := dbms_xmldom.makenode(doc => g_doc);
        addNode(p_parent => n, p_tag => p_root_tag, p_node => g_doc_root_node, p_element => g_doc_root_element);
    end newDoc;

    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_node out dbms_xmldom.DOMnode, p_root_element out dbms_xmldom.DOMelement)
    is
    begin
        newDoc(p_root_tag => p_root_tag, p_add_xml_declaration => p_add_xml_declaration);
        p_root_node := g_doc_root_node;       
        p_root_element := g_doc_root_element;        
    end newDoc;

    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_node out dbms_xmldom.DOMnode)
    is
    begin
        newDoc(p_root_tag => p_root_tag, p_add_xml_declaration => p_add_xml_declaration);
        p_root_node := g_doc_root_node;        
    end newDoc;
*/
    procedure newDoc(p_root_tag in varchar2, p_root_node out dbms_xmldom.DOMnode)
    is
        nDoc dbms_xmldom.DOMnode;
        e dbms_xmldom.DOMelement;
    begin
        --may want to check if g_doc already exists and if so free it before creating a new document
        g_doc := dbms_xmldom.newDOMdocument;
        nDoc := dbms_xmldom.makenode(doc => g_doc);
        addNode(p_parent => nDoc, p_tag => p_root_tag, p_node => p_root_node);

        g_doc_root_node := p_root_node;        
    end newDoc;

/*
    procedure newDoc(p_root_tag in varchar2, p_add_xml_declaration in boolean default false, p_root_element out dbms_xmldom.DOMelement)
    is
    begin
        newDoc(p_root_tag => p_root_tag, p_add_xml_declaration => p_add_xml_declaration);
        p_root_element := g_doc_root_element;
    end newDoc;
*/    
    /*    
    procedure addDocNode(p_tag in varchar2, p_node out dbms_xmldom.DOMnode, p_element out dbms_xmldom.DOMelement)
    is
    begin
        addNode(p_parent => g_doc_root_node, p_tag => p_tag, p_node => p_node, p_element => p_element);
    end addDocNode;

    procedure addDocNode(p_tag in varchar2, p_node out dbms_xmldom.DOMnode)
    is
        e dbms_xmldom.DOMelement;
    begin
        addDocNode(p_tag => p_tag, p_node => p_node, p_element => e);
    end addDocNode;

    procedure addDocTextNode(p_tag in varchar2, p_data in varchar2, p_element out dbms_xmldom.DOMelement)
    is
    begin
        addTextNode(p_parent => g_doc_root_node, p_tag=> p_tag, p_data => p_data, p_element => p_element);    
    end addDocTextNode;

    procedure addDocTextNode(p_tag in varchar2, p_data in varchar2)
    is
        e dbms_xmldom.DOMelement;
    begin
        addDocTextNode(p_tag => p_tag, p_data => p_data, p_element => e);
    end addDocTextNode;
    */    
/*    procedure addElementAttribute(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2)
    is
    begin
        --add the named attribute with a value directly to the element
        DBMS_XMLDOM.SETATTRIBUTE(elem => p_element, name => p_name, newvalue => p_value);
    end addElementAttribute;

    procedure addElementAttributeSetValue(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2)
    is
        a dbms_xmldom.DOMattr;
    begin
        --new doc attr, set value, set attr node to element
        a := DBMS_XMLDOM.CREATEATTRIBUTE(doc => g_doc, name => p_name);
        --setvalue should use arguments (a=> attr,value=>'xxx')
        --using named parameters fails with wrong number or types of arguments
        dbms_xmldom.setvalue(a,p_value);
        a := DBMS_XMLDOM.SETATTRIBUTENODE(elem => p_element, newAttr => a);
    end addElementAttributeSetValue;

    procedure addElementAttributeSetNodeValue(p_element in out nocopy dbms_xmldom.DOMelement, p_name in varchar2, p_value in varchar2)
    is
        a dbms_xmldom.DOMattr;
        na dbms_xmldom.DOMnode;
    begin
        --new doc attr, convert to node, set node value, set attr node to element
        a := dbms_xmldom.createattribute(doc  => g_doc, name => p_name);
        na := dbms_xmldom.makenode(a);
        dbms_xmldom.setnodevalue(n=>na,nodeValue=>p_value);    
        a := DBMS_XMLDOM.SETATTRIBUTENODE(elem => p_element, newAttr => a);
    end addElementAttributeSetNodeValue;
*/
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

    function to_XMLtype return XMLtype
    is
        l_xml xmltype;
    begin    
        l_xml := dbms_xmldom.getxmltype(g_doc);
        return l_xml;
    end to_XMLtype;

    function to_string return varchar2
    is
        l_xml xmltype;
    begin
        l_xml := to_xmltype;
        return l_xml.getstringval();
    end to_string;

    function to_clob return clob
    is
        l_xml xmltype;
    begin
        l_xml := to_xmltype;
        return l_xml.getClobVal();
    end to_clob;

    procedure freeDoc
    is
    begin
        DBMS_XMLDOM.freeDocument(g_doc);
    end freeDoc;

begin
    null;
end util_xmldom_helper;
