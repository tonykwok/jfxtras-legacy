/*
 * Copyright (c) 2008-2010, JFXtras Group
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of JFXtras nor the names of its contributors may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package org.jfxtras.animation.wipe;

import javafx.animation.Timeline;
import javafx.animation.transition.TranslateTransition;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.animation.transition.ParallelTransition;

/**
 * Wipe from left to right (vertical blinds).
 */
public def LEFT_TO_RIGHT:Integer = 1;
/**
 * Wipe from right to left (vertical blinds).
 */
public def RIGHT_TO_LEFT:Integer = 2;
/**
 * Wipe from top to bottom (horizontal blinds).
 */
public def TOP_TO_BOTTOM:Integer = 3;
/**
 * Wipe from bottom to top (horizontal blinds).
 */
public def BOTTOM_TO_TOP:Integer = 4;


/**
 * A simple wipe where the new node slides into place as the existing
 * node slides out.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class SlideWipe extends Wipe
{	/**
	 * Direction of the sliding nodes (default:
	 * {@link LEFT_TO_RIGHT LEFT_TO_RIGHT}).
	 */
	public var direction:Integer = LEFT_TO_RIGHT
		on replace
		{	if((direction<LEFT_TO_RIGHT) or (direction>BOTTOM_TO_TOP))
				direction = LEFT_TO_RIGHT;
		}

	var wasClipSet:Boolean;

        var targetX = 0;
        var targetY = 0;

	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	// Convenience
		def wpW:Number = wp.layoutBounds.width;
		def wpH:Number = wp.layoutBounds.height;
	
		if(direction==LEFT_TO_RIGHT)				// to >>> frm
		{	targetX = wpW.intValue();
			to.translateX = 0-wpW;
		}
		else if(direction==RIGHT_TO_LEFT)			// frm <<< to
		{	targetX = 0-wpW.intValue();
			to.translateX = wpW;
		}
		else if(direction==TOP_TO_BOTTOM)
		{	targetY = wpH.intValue();
			to.translateY = 0-wpH;
		}
		else if(direction==BOTTOM_TO_TOP)
		{	targetY = 0-wpH.intValue();
			to.translateY = wpH;
		}
		wp.content = [ frm,to ];
		
		// Restrict size, unless already restricted
		if(wp.clip==null)
		{	wp.clip = Rectangle
			{	width: wpW;
				height: wpH;
			}
			wasClipSet=true;
		}
		else
		{	wasClipSet=false;
		}

	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	ParallelTransition
		{	content: [
				TranslateTransition
				{	duration: this.time;
					node: frm;
					toX: targetX;  toY: targetY;
				}
				TranslateTransition
				{	duration: this.time;
					node: to;
					toX: 0;  toY: 0;
				}
			]
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	frm.translateX = 0;
		frm.translateY = 0;
                to.translateX = 0;
		to.translateY = 0;
		wp.content = [ to ];

		if(wasClipSet)  wp.clip=null;
	}
}