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
 * Wipe from/to the left edge.
 */
public def LEFT:Integer = 1;
/**
 * Wipe from/to the right edge.
 */
public def RIGHT:Integer = 2;
/**
 * Wipe from/to the top edge.
 */
public def TOP:Integer = 3;
/**
 * Wipe from/to the bottom edge.
 */
public def BOTTOM:Integer = 4;
/**
 * Wipe from/to the top left corner, outwards.
 */
public def TOP_LEFT:Integer = 5;
/**
 * Wipe from/to the top right corner, outwards.
 */
public def TOP_RIGHT:Integer = 6;
/**
 * Wipe from/to the bottom left corner, outwards.
 */
public def BOTTOM_LEFT:Integer = 7;
/**
 * Wipe from/to the bottom right corner, outwards.
 */
public def BOTTOM_RIGHT:Integer = 8;

/**
 * New node swings in, hiding existing node.
 */
public def IN:Integer = 101;
/**
 * Existing node swings away, revealing new node.
 */
public def OUT:Integer = 102;


/**
 * A 3D wipe which swings nodes on or off of the display, anchored by
 * a given edge or corner.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class SwingInOutWipe extends Wipe
{	/**
	 * Direction of the wipe (default:
	 * {@link IN IN}).
	 */
	public var direction:Integer = IN
		on replace
		{	if((direction<IN) or (direction>OUT))
				direction = IN;
		}
	/**
	 * Anchor of the wipe: which edge or a corner provides the 'hinge'
	 * (default: {@link LEFT LEFT}).
	 */
	public var anchor:Integer = LEFT
		on replace
		{	if((anchor<LEFT) or (anchor>BOTTOM_RIGHT))
				anchor = LEFT;
		}
	
	var origEffect:Effect;
	var startTransform:PerspectiveTransform;
	var endTransform:PerspectiveTransform;
	def pers:PerspectiveTransform = PerspectiveTransform {};
	
	
	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	def wpW:Number = wp.layoutBounds.width;
		def wpH:Number = wp.layoutBounds.height;
				
		def xx:Number = wpW/8;
		def yy:Number = wpH/8;
		def pt1 = if(anchor==LEFT)
			PerspectiveTransform
			{	ulx:0;      uly:0;        urx:0;       ury:0+yy;
				llx:0;      lly:wpH;      lrx:0;       lry:wpH-yy;
			}
		else if(anchor==RIGHT)
			PerspectiveTransform
			{	ulx:wpW;    uly:0+yy;      urx:wpW;     ury:0;
				llx:wpW;    lly:wpH-yy;    lrx:wpW;     lry:wpH;
			}
		else if(anchor==TOP)
			PerspectiveTransform
			{	ulx:0;      uly:0;         urx:wpW;     ury:0;
				llx:0+xx    lly:0;         lrx:wpW-xx;  lry:0;
			}
		else if(anchor==BOTTOM)
			PerspectiveTransform
			{	ulx:0+xx    uly:wpH;       urx:wpW-xx;  ury:wpH;
				llx:0;      lly:wpH;       lrx:wpW;     lry:wpH;
			}
		else if(anchor==TOP_LEFT)
			PerspectiveTransform
			{	ulx:0;      uly:0;         urx:wpW;     ury:0;
				llx:0+xx;   lly:0;         lrx:0+xx;    lry:0;
			}
		else if(anchor==TOP_RIGHT)
			PerspectiveTransform
			{	ulx:0;      uly:0;         urx:wpW;     ury:0;
				llx:wpW-xx; lly:0;         lrx:wpW-xx;  lry:0;
			}
		else if(anchor==BOTTOM_LEFT)
			PerspectiveTransform
			{	ulx:0+xx    uly:wpH;       urx:0+xx;    ury:wpH;
				llx:0;      lly:wpH;       lrx:wpW;     lry:wpH;
			}
		else if(anchor==BOTTOM_RIGHT)
			PerspectiveTransform
			{	ulx:wpW-xx; uly:wpH;       urx:wpW-xx    ury:wpH;
				llx:0;      lly:wpH;       lrx:wpW;      lry:wpH;
			}
		else
			PerspectiveTransform {}
		
		def pt2 = PerspectiveTransform
		{	ulx:0;  uly:0;     urx:wpW;  ury:0;
			llx:0;  lly:wpH;   lrx:wpW; lry:wpH;
		}
		
		// In: to is ontop / out: frm is ontop
		if(direction==IN)
		{	startTransform = pt1;
			endTransform = pt2;
			origEffect = to.effect;
			to.effect = pers;
			wp.content = [frm,to];
		}
		else
		{	startTransform = pt2;
			endTransform = pt1;
			origEffect = frm.effect;
			frm.effect = pers;
			wp.content = [to,frm];
		}
				
		pers.ulx = startTransform.ulx;  pers.uly = startTransform.uly;
		pers.urx = startTransform.urx;  pers.ury = startTransform.ury;
		pers.llx = startTransform.llx;  pers.lly = startTransform.lly;
		pers.lrx = startTransform.lrx;  pers.lry = startTransform.lry;
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: (this.time/2);
					values:
					[	pers.ulx => endTransform.ulx tween Interpolator.EASEIN ,
						pers.uly => endTransform.uly tween Interpolator.EASEIN ,

						pers.urx => endTransform.urx tween Interpolator.EASEIN ,
						pers.ury => endTransform.ury tween Interpolator.EASEIN ,

						pers.llx => endTransform.llx tween Interpolator.EASEIN ,
						pers.lly => endTransform.lly tween Interpolator.EASEIN ,

						pers.lrx => endTransform.lrx tween Interpolator.EASEIN ,
						pers.lry => endTransform.lry tween Interpolator.EASEIN 
					]
				}
			]
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	if(direction==IN)
		{	to.effect = origEffect;
		}
		else
		{	frm.effect = origEffect;
		}
		wp.content = [ to ];
	}
}