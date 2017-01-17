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
import javafx.scene.effect.Effect;
import javafx.scene.effect.PerspectiveTransform;
import javafx.scene.Node;
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
 * Performs a 3D style rotation, as if the start and end nodes are on
 * different sides of a piece of paper..
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class Flip180Wipe extends Wipe
{	/**
	 * Direction of the nearest edge of the rotation (default:
	 * {@link LEFT_TO_RIGHT LEFT_TO_RIGHT}).
	 */
	public var direction:Integer = LEFT_TO_RIGHT
		on replace
		{	if((direction<LEFT_TO_RIGHT) or (direction>BOTTOM_TO_TOP))
				direction = LEFT_TO_RIGHT;
		}	
	
	var origToEffect:Effect;
	var origFrmEffect:Effect;
	var origClip:Node;
	var startTransform:PerspectiveTransform;
	var mid1Transform:PerspectiveTransform;
	var mid2Transform:PerspectiveTransform;
	def pers:PerspectiveTransform = PerspectiveTransform {};
	
	
	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	def wpW:Number = wp.layoutBounds.width;
		def wpH:Number = wp.layoutBounds.height;
		
		origClip = wp.clip;
		wp.clip = Rectangle
		{	x:0;  y:0;  width:wpW;  height:wpH;
		}
		
		startTransform = PerspectiveTransform
		{	ulx:0;  uly:0;    urx:wpW;  ury:0;
			llx:0;  lly:wpH;  lrx:wpW;  lry:wpH;
		}
		
		def xx:Number = wpW/8;
		def yy:Number = wpH/8;
		def l2r = PerspectiveTransform
		{	ulx:wpW/2;  uly:0-yy;     urx:wpW/2;  ury:0+yy;
			llx:wpW/2;  lly:wpH+yy;   lrx:wpW/2;  lry:wpH-yy;
		}
		def r2l = PerspectiveTransform
		{	ulx:wpW/2;  uly:0+yy;     urx:wpW/2;  ury:0-yy;
			llx:wpW/2;  lly:wpH-yy;   lrx:wpW/2;  lry:wpH+yy;
		}
		def t2b = PerspectiveTransform
		{	ulx:0-xx;  uly:wpH/2;     urx:wpW+xx;  ury:wpH/2;
			llx:0+xx;  lly:wpH/2;     lrx:wpW-xx;  lry:wpH/2;
		}
		def b2t = PerspectiveTransform
		{	ulx:0+xx;  uly:wpH/2;     urx:wpW-xx;  ury:wpH/2;
			llx:0-xx;  lly:wpH/2;     lrx:wpW+xx;  lry:wpH/2;
		}
		
		mid1Transform = if(direction==LEFT_TO_RIGHT) l2r			
		else if(direction==RIGHT_TO_LEFT) r2l
		else if(direction==TOP_TO_BOTTOM) t2b
		else if(direction==BOTTOM_TO_TOP) b2t
		else PerspectiveTransform {}

		mid2Transform = if(direction==LEFT_TO_RIGHT) r2l
		else if(direction==RIGHT_TO_LEFT) l2r
		else if(direction==TOP_TO_BOTTOM) b2t
		else if(direction==BOTTOM_TO_TOP) t2b
		else PerspectiveTransform {}
			
		pers.ulx = startTransform.ulx;  pers.uly = startTransform.uly;
		pers.urx = startTransform.urx;  pers.ury = startTransform.ury;
		pers.llx = startTransform.llx;  pers.lly = startTransform.lly;
		pers.lrx = startTransform.lrx;  pers.lry = startTransform.lry;
		
		origFrmEffect = frm.effect;
		origToEffect = to.effect;
		frm.effect = pers;
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: (this.time/2);
					values:
					[	pers.ulx => mid1Transform.ulx tween Interpolator.EASEIN ,
						pers.uly => mid1Transform.uly tween Interpolator.EASEIN ,

						pers.urx => mid1Transform.urx tween Interpolator.EASEIN ,
						pers.ury => mid1Transform.ury tween Interpolator.EASEIN ,

						pers.llx => mid1Transform.llx tween Interpolator.EASEIN ,
						pers.lly => mid1Transform.lly tween Interpolator.EASEIN ,

						pers.lrx => mid1Transform.lrx tween Interpolator.EASEIN ,
						pers.lry => mid1Transform.lry tween Interpolator.EASEIN 
					]
				} ,
				
				KeyFrame
				{	time: (this.time/2);
					values:
					[	pers.ulx => mid2Transform.ulx ,
						pers.uly => mid2Transform.uly ,

						pers.urx => mid2Transform.urx ,
						pers.ury => mid2Transform.ury ,

						pers.llx => mid2Transform.llx ,
						pers.lly => mid2Transform.lly ,

						pers.lrx => mid2Transform.lrx ,
						pers.lry => mid2Transform.lry 
					]
					action: function()
					{	to.effect = pers;
						wp.content = [ to ];
					}
				} ,
				KeyFrame
				{	time: this.time;
					values:
					[	pers.ulx => startTransform.ulx tween Interpolator.EASEOUT ,
						pers.uly => startTransform.uly tween Interpolator.EASEOUT ,

						pers.urx => startTransform.urx tween Interpolator.EASEOUT ,
						pers.ury => startTransform.ury tween Interpolator.EASEOUT ,

						pers.llx => startTransform.llx tween Interpolator.EASEOUT ,
						pers.lly => startTransform.lly tween Interpolator.EASEOUT ,

						pers.lrx => startTransform.lrx tween Interpolator.EASEOUT ,
						pers.lry => startTransform.lry tween Interpolator.EASEOUT 
					]
				}
			]
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	frm.effect = origFrmEffect;
		to.effect = origToEffect;
		wp.clip = origClip;

		if(wp.content[0] != to)
			wp.content = [ to ];
	}
}