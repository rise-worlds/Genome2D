/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.node;

import com.genome2d.node.factory.GNodeFactory;

/**
    Node pool based on prototypes
**/
@:allow(com.genome2d.node.GNode)
@:access(com.genome2d.node.GNode)
class GNodePool
{
	private var g2d_first:GNode;
	private var g2d_last:GNode;
	
	private var g2d_prototype:Xml;
	
	private var g2d_maxCount:Int;
	
	private var g2d_cachedCount:Int = 0;
    public function getCachedCount():Int {
        return g2d_cachedCount;
    }

	public function new(p_prototype:Xml, p_maxCount:Int = 0, p_precacheCount:Int = 0) {
		g2d_prototype = p_prototype;
		g2d_maxCount = p_maxCount;
		
		for (i in 0...p_precacheCount) {
			g2d_createNew(true);
		}
	}
	
	public function getNext():GNode {
		var node:GNode;

		if (g2d_first == null || g2d_first.isActive()) {
			node = g2d_createNew();
		} else {
			node = g2d_first;
			node.setActive(true);
		}
		return node;
	}

	private function g2d_putToFront(p_node:GNode):Void {
		if (p_node == g2d_first) return;
		
		if (p_node.g2d_poolNext != null) p_node.g2d_poolNext.g2d_poolPrevious = p_node.g2d_poolPrevious;
		if (p_node.g2d_poolPrevious != null) p_node.g2d_poolPrevious.g2d_poolNext = p_node.g2d_poolNext;
		if (p_node == g2d_last) g2d_last = g2d_last.g2d_poolPrevious;
		
		if (g2d_first != null) g2d_first.g2d_poolPrevious = p_node;
		p_node.g2d_poolPrevious = null;
		p_node.g2d_poolNext = g2d_first;
		g2d_first = p_node;
	}

	private function g2d_putToBack(p_node:GNode):Void {
		if (p_node == g2d_last) return;
		
		if (p_node.g2d_poolNext != null) p_node.g2d_poolNext.g2d_poolPrevious = p_node.g2d_poolPrevious;
		if (p_node.g2d_poolPrevious != null) p_node.g2d_poolPrevious.g2d_poolNext = p_node.g2d_poolNext;
		if (p_node == g2d_first) g2d_first = g2d_first.g2d_poolNext;
			
		if (g2d_last != null) g2d_last.g2d_poolNext = p_node;
		p_node.g2d_poolPrevious = g2d_last;
		p_node.g2d_poolNext = null;
		g2d_last = p_node;
	}
	
	private function g2d_createNew(p_precache:Bool = false):GNode {
		var node:GNode = null;
		if (g2d_maxCount == 0 || g2d_cachedCount < g2d_maxCount) {
			g2d_cachedCount++;
			node = GNodeFactory.createFromPrototype(g2d_prototype);
			if (p_precache) node.setActive(false);
			node.g2d_pool = this;
			
			if (g2d_first == null) {
				g2d_first = node;
				g2d_last = node;
			} else {
				node.g2d_poolPrevious = g2d_last;
				g2d_last.g2d_poolNext = node;
				g2d_last = node;
			}
		}
		
		return node;
	}
	
	public function dispose():Void {
		while (g2d_first != null) {
			var next:GNode = g2d_first.g2d_poolNext;
			g2d_first.dispose();
			g2d_first = next;
		}
	}
}