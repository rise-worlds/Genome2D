/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.node.factory;

import com.genome2d.components.GComponent;
import com.genome2d.error.GError;

/**
    Node creation factory used to create `GNode` instances
**/
class GNodeFactory
{
	static public function createNode(p_name:String = ""):GNode {
		return new GNode(p_name);
	}
	
	static public function createNodeWithComponent(p_componentClass:Class<GComponent>, p_name:String = "", p_lookupClass:Class<GComponent> = null):GComponent {
		var node:GNode = new GNode();
			
		return node.addComponent(p_componentClass, p_lookupClass);
	}
	
	static public function createFromPrototype(p_prototypeXml:Xml):GNode {
		if (p_prototypeXml == null) new GError("Null prototype");

        if (p_prototypeXml.nodeType == Xml.Document) {
            p_prototypeXml = p_prototypeXml.firstChild();
        }

        if (p_prototypeXml.nodeName != "node") new GError("Incorrect GNode prototype XML");

		var node:GNode = new GNode();
		node.mouseEnabled = (p_prototypeXml.get("mouseEnabled") == "true") ? true : false;
		node.mouseChildren = (p_prototypeXml.get("mouseChildren") == "true") ? true : false;

		var it:Iterator<Xml> = p_prototypeXml.elements();
		
		while (it.hasNext()) {
			var xml:Xml = it.next();
			if (xml.nodeName == "components") {
				var componentsIt:Iterator<Xml> = xml.elements();
				while (componentsIt.hasNext()) {
					var componentXml:Xml = componentsIt.next();

					node.addComponentPrototype(componentXml);
				}
			}
			
			if (xml.nodeName == "children") {
				var childIt:Iterator<Xml> = xml.elements();
				while (childIt.hasNext()) {
					node.addChild(GNodeFactory.createFromPrototype(childIt.next()));
				}
			}
		}
		
		return node;
	}
}