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
import javafx.animation.transition.SequentialTransition;
import javafx.scene.Node;
import javafx.scene.layout.Container;

/**
 * A wipe-supporting container.  This node class acts like any other
 * JavaFX container, except it can only have once child, that can be
 * changed using an assigned wipe effect.
 * <p/>
 * This class is at the heart of the wipe library.  A
 * {@link WipePanel WipePanel} can be plugged into the scene graph like
 * any other container, except for two things: a {@link Wipe Wipe} subclass
 * can be assigned to act as a transition effect, and an
 * event {@link action function} can be declared to run when the transition
 * is over.  To kick off a wipe transition, and change the
 * {@link WipePanel WipePanel}'s contents, call the {@link next(:Node) next()}
 * function,
 * <p/>
 * <code><pre>wiper = WipePanel {
 *   content: [ node1 ]
 *   wipe: FadeWipe { time: 1s }
 *   action: function() { println("Done"); }
 * }
 * // ...
 * wiper.next(node2);</pre></code>
 *
 * @author             Simon Morris
 * @since              0.1
 */
public class XWipePanel extends Container
{	/**
	 * Wipe effect to apply whenever {@link next(:Node) next()} is called.
	 */
	public var wipe:Wipe on replace oldVal = newVal
	{	kill(oldVal);
	}
	/**
	 * Function to call when wipe is finished.
	 */
	public var action:function():Void;

	var currTLine:Timeline = null;
	var currTo:Node = null;
	var currFrm:Node = null;


	override function doLayout() : Void
	{	
		for(n in getManaged(content))
		{	layoutNode(n , n.layoutX,n.layoutY, getNodePrefWidth(n),getNodePrefHeight(n));
		}
	}

	/**
	 * Change the node content of the {@link WipePanel WipePanel}, using the
	 * assigned wipe effect,
	 *
	 * @param to       Wipe the existing node content to this node.
	 */
	public function next(to:Node) : Void
	{	// Kill the current wipe (if active)
		kill(wipe);

		// Current scene graph node
		def frm:Node = this.content[0];
		// Remember frm and to (see kill())
		currFrm=frm;  currTo=to;

		// Preform all three stages of the wipe
		wipe.preWipe(this, frm, to);
		currTLine = SequentialTransition
		{	content:
			[	wipe.wipe(this, frm, to)
			]
			action: function()
			{	// Stop the wiper timeline (believe it or not, it's not
				// always complete by the time this action() function runs)
				currTLine.stop();
				currTo=null;  currFrm=null;
				// Post wipe clean up
				wipe.postWipe(this, frm, to);
				if(action!=null)  action();
			}
	        }
		currTLine.playFromStart();
        }

	// If a current wipe is still animating, shut it down gracefully
	function kill(w:Wipe) : Void
	{	if(currTLine!=null and currTLine.running)
		{	// Stop the animation
			currTLine.stop();
			currTLine = null;
			// Post wipe clean up
			w.postWipe(this , currFrm , currTo);
		}
	}
}