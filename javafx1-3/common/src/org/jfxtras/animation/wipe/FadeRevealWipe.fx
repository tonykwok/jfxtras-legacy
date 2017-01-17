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
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;

/**
 * Wipe from left to right.
 */
public def LEFT_TO_RIGHT:Integer = 1;
/**
 * Wipe from right to left.
 */
public def RIGHT_TO_LEFT:Integer = 2;
/**
 * Wipe from top to bottom.
 */
public def TOP_TO_BOTTOM:Integer = 3;
/**
 * Wipe from bottom to top.
 */
public def BOTTOM_TO_TOP:Integer = 4;


/**
 * Experimental.  Do no use.
 */
public class FadeRevealWipe extends Wipe
{	/**
	 * Direction of the wipe (default:
	 * {@link LEFT_TO_RIGHT LEFT_TO_RIGHT}).
	 */
	public var direction:Integer = LEFT_TO_RIGHT
		on replace
		{	if((direction<LEFT_TO_RIGHT) or (direction>BOTTOM_TO_TOP))
				direction = LEFT_TO_RIGHT;
		}	

	var origClip:Node;
	var rect:Rectangle;
	var endX:Number;
	var endY:Number;

	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	def xx:Number = wp.layoutBounds.width;
		def yy:Number = wp.layoutBounds.height;
	
		if(direction == LEFT_TO_RIGHT)
		{	rect = Rectangle
			{	width: xx*2;  height: yy;
				translateX: 0-xx*2;  translateY: 0;
				fill: LinearGradient
				{	proportional:false;  endX: xx*2;  endY:0;
					stops:
					[	Stop { offset:0.5;  color: Color.WHITE; } ,
						Stop { offset:1.0;  color: Color.TRANSPARENT; }
					]
				}
				cache: true;
			}
			endX=0;  endY=0;
		}
		else if(direction == RIGHT_TO_LEFT)
		{	rect = Rectangle
			{	width: xx*2;  height: yy;
				translateX: xx;  translateY: 0;
				fill: LinearGradient
				{	proportional:false;  endX: xx*2;  endY:0;
					stops:
					[	Stop { offset:0.0;  color: Color.TRANSPARENT; } ,
						Stop { offset:0.5;  color: Color.WHITE; }
					]
				}
			}
			endX=0-xx;  endY=0;
		}
		else
		{	rect = Rectangle {}
		}
			
		origClip = to.clip;
		to.clip = rect;
		wp.content = [ frm,to ];
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	/*Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: (this.time/2);
					values:
					[	rect => Color.WHITE tween Interpolator.LINEAR ,
						col1 => Color.WHITE tween Interpolator.LINEAR
					]
				} 
			]
		}*/
		TranslateTransition
		{	node: rect;
			duration: this.time;
			toX: endX;  toY: endY;
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	to.clip = origClip;
		wp.content = [ to ];
	}
}