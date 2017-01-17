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
 * Wipe from the edge of the display, inwards.
 */
public def IN:Integer = 101;
/**
 * Wipe from the center of the display, outwards.
 */
public def OUT:Integer = 102;

/**
 * A shaped wipe in which one node is gradually revealed from/to the
 * center of the {@link WipePanel WipePanel} over another.
 * Effectively the wipe is an expanding/contracting shaped viewport,
 * not unlike {@link RevealWipe RevealWipe}.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class ShapeWipe extends Wipe
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
	 * The shape to use for the reveal area.
	 */
	public var shape:Node;
	
	var origClip:Node;
	var endScale:Number;
	
	
	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	if(shape==null)  shape = Rectangle {}
		if(direction==IN)
		{	shape.scaleX = 0;
			shape.scaleY = 0;
			endScale = 1;
			
			origClip = to.clip;
			to.clip = shape;
			
			wp.content = [ frm,to ];
		}
		else
		{	shape.scaleX = 1;
			shape.scaleY = 1;
			endScale = 0;
			
			origClip = frm.clip;
			frm.clip = shape;
			
			wp.content = [ to,frm ];
		}
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: this.time;
                                        def s = shape;
					values:
					[	s.scaleX => endScale tween Interpolator.LINEAR ,
						s.scaleY => endScale tween Interpolator.LINEAR
					]
				}
			]
		}
	}
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	if(direction==IN)
		{	to.clip = origClip;
		}
		else
		{	frm.clip = origClip;
		}
		wp.content = [ to ];
	}
}