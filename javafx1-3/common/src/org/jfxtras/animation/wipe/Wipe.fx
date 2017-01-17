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
import javafx.scene.Node;

/**
 * Root mixin for all wipe classes.  Extend this if you want to create
 * your own wipe effects.
 * <p/>
 * Node: {@link Wipe.postWipe() postWipe()} must always
 * install the 'to' node into the scene graph, as
 * {@link Wipe.wipe() wipe()} may be terminated
 * mid-animation -- the scene graph <strong>MUST</strong> always
 * result with the 'to' node in place after a wipe, not 'frm'.
 *
 * @author             Simon Morris
 * @since              0.1
 */
public mixin class Wipe
{	/**
	 * Duration of the wipe effect.
	 *
	 * @default        1s
	 */
	public var time:Duration = 1s;

	/**
	 * Called before the wipe begins.  If the wipe needs to perform
	 * any prep before running, or clean up from a previous run, this is
	 * where it should be done.
	 *
	 * @param wp       The containing panel
	 * @param frm      The node showing at the start of the wipe
	 * @param to       The node showing at the end of the wipe
	 */
	public abstract function preWipe(wp:XWipePanel,frm:Node,to:Node) : Void;

	/**
	 * Creates a timeline object that performs the wipe.
	 *
	 * @param wp       The containing panel
	 * @param frm      The node showing at the start of the wipe
	 * @param to       The node showing at the end of the wipe
	 */
	public abstract function wipe(wp:XWipePanel,frm:Node,to:Node) : Timeline;

	/**
	 * Called after the wipe ends.  Any clean up should be done
	 * here, and the 'to' node should be hooked into the
	 * {@link WipePanel WipePanel} as its only child.
	 * <strong>Important:</strong> this function is called even if the
	 * wipe was  abandoned mid-way through,  so do not assume the 'to'
	 * node is in its final state.
	 *
	 * @param wp       The containing panel
	 * @param frm      The node showing at the start of the wipe
	 * @param to       The node showing at the end of the wipe
	 */
	public abstract function postWipe(wp:XWipePanel,frm:Node,to:Node) : Void;
}