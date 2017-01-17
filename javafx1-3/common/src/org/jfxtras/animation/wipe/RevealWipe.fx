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
import javafx.scene.shape.Rectangle;

/**
 * Not supported, yet.
 */
public def CUSTOM:Integer = 0;
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
 * Wipe from the top left corner, outwards.
 */
public def TOP_LEFT:Integer = 5;
/**
 * Wipe from the top right corner, outwards.
 */
public def TOP_RIGHT:Integer = 6;
/**
 * Wipe from the bottom left corner, outwards.
 */
public def BOTTOM_LEFT:Integer = 7;
/**
 * Wipe from the bottom right corner, outwards.
 */
public def BOTTOM_RIGHT:Integer = 8;

/**
 * A split screen wipe in which one node is gradually revealed in place
 * over another.  Effectively the wipe is an expanding rectangular
 * viewport, that can start from either an edge of the screen or a corner.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class RevealWipe extends Wipe
{	/**
	 * Direction of the wipe (default:
	 * {@link LEFT_TO_RIGHT LEFT_TO_RIGHT}).
	 */
	public var direction:Integer = LEFT_TO_RIGHT
		on replace
		{	if((direction<CUSTOM) or (direction>BOTTOM_RIGHT))
				direction = LEFT_TO_RIGHT;
		}	
	var startRectangle:Rectangle;
	var endRectangle:Rectangle;
	var toOrigClip:Node;
	def toRect:Rectangle = Rectangle{}
	
	
	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	def wpW:Number = wp.layoutBounds.width;
		def wpH:Number = wp.layoutBounds.height;
		startRectangle = if(direction==LEFT_TO_RIGHT)
			Rectangle
			{	x:0;  y:0;  width:0;  height:wpH;
			}
		else if(direction==RIGHT_TO_LEFT)
			Rectangle
			{	x:wpW;  y:0;  width:0;  height:wpH;
			}
		else if(direction==TOP_TO_BOTTOM)
			Rectangle
			{	x:0;  y:0;  width:wpW;  height:0;
			}
		else if(direction==BOTTOM_TO_TOP)
			Rectangle
			{	x:0;  y:wpH;  width:wpW;  height:0;
			}
		else if(direction==TOP_LEFT)
			Rectangle
			{	x:0;  y:0;  width:0;  height:0;
			}
		else if(direction==TOP_RIGHT)
			Rectangle
			{	x:wpW;  y:0;  width:0;  height:0;
			}
		else if(direction==BOTTOM_LEFT)
			Rectangle
			{	x:0;  y:wpH;  width:0;  height:0;
			}
		else if(direction==BOTTOM_RIGHT)
			Rectangle
			{	x:wpW;  y:wpH;  width:0;  height:0;
			}
		else if(direction==CUSTOM)
			startRectangle
		else
			Rectangle {}
			
		endRectangle = Rectangle
		{	x:0;  y:0;  width:wpW;  height:wpH;
		}

		toRect.x = startRectangle.x;
		toRect.y = startRectangle.y;
		toRect.width = startRectangle.width;
		toRect.height = startRectangle.height;

		toOrigClip = to.clip;
		
		to.clip = toRect;
		wp.content = [ frm,to ];
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: this.time;
					values:
					[	toRect.x => endRectangle.x 
							tween Interpolator.LINEAR ,
						toRect.y => endRectangle.y 
							tween Interpolator.LINEAR ,
						toRect.width => endRectangle.width 
							tween Interpolator.LINEAR ,
						toRect.height => endRectangle.height 
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