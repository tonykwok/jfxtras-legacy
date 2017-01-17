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

package org.jfxtras.scene;

import javafx.scene.*;
import javafx.animation.*;

/**
 * @author Tom Eugelink
 *
 * extended CustomNode which adds simply animation and the management of the timelines.
 */

abstract public class AutoAnimatingCustomNode extends CustomNode
{
	// the node to be animated
    public var node: javafx.scene.Node = this;

	// speed
	def defaultDuration : Duration = 300ms;

    // ====================================================================
    // animated X

    /**
     * animate
     */
    public function animateXTo(value:Float, timespan:Duration, startupDelay:Duration)
	{
		// optimize: only if something is changed
		if (value.equals(node.translateX)) return;
		
    	// stop what we're doing
    	if (iTimelineX.running) iTimelineX.pause();

    	// start for new target
		def lInitialValue = node.translateX;
                def n = node;
	    iTimelineX = Timeline {	keyFrames:
		[	KeyFrame
//			{
//				time: 0s;
//				values: n.translateX => lInitialValue;
//			}
//		,	KeyFrame
			{
				time: startupDelay;
				values: n.translateX => lInitialValue;
				canSkip: true;
			}
		,	KeyFrame
			{
				time: startupDelay + timespan;
				values: n.translateX => value tween Interpolator.EASEOUT;
				action: function()
				{
					iTimelineX = null;
				};
			}
		]};
     	iTimelineX.play();
	}
    var iTimelineX: Timeline;

    /**
     * animate in 2 seconds
     */
    public function animateXTo(value:Float)
	{
        animateXTo(value, defaultDuration, 0s);
    }

    /**
     * no animation
     */
    public function jumpXTo(value:Float)
	{
    	// stop
    	if (iTimelineX.running) iTimelineX.stop();

        // jump
        node.translateX = value;
    }


    // ====================================================================
    // animated Y

    /**
     * animate
     */
    public function animateYTo(value:Float, timespan:Duration, startupDelay:Duration)
	{
		// optimize: only if something is changed
		if (value.equals(node.translateY)) return;

    	// stop what we're doing
    	if (iTimelineY.running) iTimelineY.pause();

    	// start for new target
		def lInitialValue = node.translateY;
                def n = node;
	    iTimelineY = Timeline {	keyFrames:
		[	KeyFrame
//			{
//				time: 0s;
//				values: n.translateY => lInitialValue;
//			}
//		,	KeyFrame
			{
				time: startupDelay;
				values: n.translateY => lInitialValue;
				canSkip: true
			}
		,	KeyFrame
			{
				time: startupDelay + timespan;
				values: n.translateY => value tween Interpolator.EASEOUT;
				action: function()
				{
					iTimelineY = null;
				};
			}
		]};
     	iTimelineY.play();
	}
    var iTimelineY: Timeline;

    /**
     * animate in 2 seconds
     */
    public function animateYTo(value:Float)
	{
        animateYTo(value, defaultDuration, 0s);
    }

    /**
     * no animation
     */
    public function jumpYTo(value:Float)
	{
    	// stop
    	if (iTimelineY.running) iTimelineY.stop();

        // jump
        node.translateY = value;
    }

    // ====================================================================
    // animated Opacity

    /**
     * animate
     */
    public function animateOpacityTo(value:Float, timespan:Duration, startupDelay:Duration)
	{
		// optimize: only if something is changed
		if (value.equals(node.opacity)) return;

    	// stop what we're doing
    	if (iTimelineOpacity.running) iTimelineOpacity.pause();

    	// start for new target
		def lInitialValue = node.opacity;
                def n = node;
	    iTimelineOpacity = Timeline {	keyFrames:
		[	KeyFrame
//			{
//				time: 0s;
//				values: n.opacity => lInitialValue;
//			}
//		,	KeyFrame
			{
				time: startupDelay;
				values: n.opacity => lInitialValue;
				canSkip: true
			}
		,	KeyFrame
			{
				time: startupDelay + timespan;
				values: n.opacity => value tween Interpolator.EASEOUT;
				action: function()
				{
					iTimelineOpacity = null;
				};
			}
		]};
     	iTimelineOpacity.play();
	}
    var iTimelineOpacity: Timeline;

    /**
     * animate in 2 seconds
     */
    public function animateOpacityTo(value:Float)
	{
        animateOpacityTo(value, defaultDuration, 0s);
    }

    /**
     * no animation
     */
    public function jumpOpacityTo(value:Float)
	{
    	// stop
    	if (iTimelineOpacity.running) iTimelineOpacity.stop();

        // jump
        node.opacity = value;
    }
}