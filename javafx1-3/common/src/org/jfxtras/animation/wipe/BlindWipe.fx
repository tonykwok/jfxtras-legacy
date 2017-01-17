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

import javafx.animation.Interpolator;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;

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
 * Wipes between two nodes like a set of window blinds, with multiple
 * horizontal or vertical sections sliding into view.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class BlindWipe extends Wipe
{	/**
	 * Direction of the blinds (default:
	 * {@link LEFT_TO_RIGHT LEFT_TO_RIGHT}).
	 */
	public var direction:Integer = LEFT_TO_RIGHT
		on replace
		{	if((direction<LEFT_TO_RIGHT) or (direction>BOTTOM_TO_TOP))
				direction = LEFT_TO_RIGHT;
		}
	/**
	 * Number of blind segments (default 5).
	 */
	public var blinds:Integer = 5
		on replace
		{	if(blinds<0)  blinds=0;
			if(blinds>10)  blinds=10;
		}
	
	var endRectangle:Rectangle;
	var toOrigClip:Node;
	var toRect:Rectangle;
	
	
	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	def wpW:Number = wp.layoutBounds.width;
		def wpH:Number = wp.layoutBounds.height;
		
		def xx:Number = wpW/blinds;
		def yy:Number = wpH/blinds;
		toRect = if(direction==LEFT_TO_RIGHT)
			Rectangle
			{	x:0;  y:0;  width:0;  height:wpH;
			}
		else if(direction==RIGHT_TO_LEFT)
			Rectangle
			{	x:xx;  y:0;  width:0;  height:wpH;
			}
		else if(direction==TOP_TO_BOTTOM)
			Rectangle
			{	x:0;  y:0;  width:wpW;  height:0;
			}
		else if(direction==BOTTOM_TO_TOP)
			Rectangle
			{	x:0;  y:yy;  width:wpW;  height:0;
			}
		else
			Rectangle {}
			
		endRectangle = if(direction<3)
			Rectangle
			{	x:0;  y:0;  width:xx;  height:wpH;
			}
		else
			Rectangle
			{	x:0;  y:0;  width:wpW;  height:yy;
			}

		toOrigClip = to.clip;
		
		to.clip = Group
		{	content: for(i in [0..<blinds])
			{	var r = Rectangle
				{	x: bind toRect.x;
					y: bind toRect.y;
					width: bind toRect.width;
					height: bind toRect.height;
				}
				if(direction<=2) { r.layoutX = xx*i; }
					else { r.layoutY = yy*i; }
				r;
			}
		}
		wp.content = [ frm,to ];
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: this.time;
                                        def tr = toRect;
					values:
					[	tr.x => endRectangle.x
							tween Interpolator.LINEAR ,
						tr.y => endRectangle.y
							tween Interpolator.LINEAR ,
						tr.width => endRectangle.width
							tween Interpolator.LINEAR ,
						tr.height => endRectangle.height
							tween Interpolator.LINEAR
					]
				}
			]
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	wp.content = [ to ];
		to.clip = toOrigClip;
	}
}