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

/**
 * Fades between two nodes, at the same time as the existing node shrinks
 * towards the center of the {@link WipePanel WipePanel} and the new
 * node expands in its place.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class FadeZoomWipe extends Wipe
{	var origToOpacity:Number;
	var origToScaleX:Number;
	var origToScaleY:Number;

	var origFrmOpacity:Number;
	var origFrmScaleX:Number;
	var origFrmScaleY:Number;

	override function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	origToOpacity = to.opacity;
		origToScaleX = to.scaleX;
		origToScaleY = to.scaleY;

		origFrmOpacity = frm.opacity;
		origFrmScaleX = frm.scaleX;
		origFrmScaleY = frm.scaleY;

		to.opacity = 0;
		to.scaleX = 0;  to.scaleY = 0;
		wp.content = [ frm,to ];
	}
	
	override function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline
	{	Timeline
		{	keyFrames:
			[	KeyFrame
				{	time: this.time;
                                        def t = to;
                                        def f = frm;
					values:
					[	t.opacity => origToOpacity tween Interpolator.EASEOUT ,
						t.scaleX => origToScaleX tween Interpolator.EASEOUT ,
						t.scaleY => origToScaleY tween Interpolator.EASEOUT ,
						f.opacity => 0 tween Interpolator.EASEIN ,
						f.scaleX => 0 tween Interpolator.EASEIN ,
						f.scaleY => 0 tween Interpolator.EASEIN
					]
				}
                        ]
                }
        }
	
	override function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void
	{	frm.opacity = origFrmOpacity;
		frm.scaleX = origFrmScaleX;
		frm.scaleY = origFrmScaleY;

		to.opacity = origToOpacity;
		to.scaleX = origToScaleX;
		to.scaleY = origToScaleY;

		wp.content = [ to ];
	}
}