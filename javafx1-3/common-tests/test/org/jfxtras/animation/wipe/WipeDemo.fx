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

import javafx.scene.Node;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.Flow;
import javafx.scene.layout.Stack;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.RadialGradient;
import javafx.scene.paint.Stop;
import javafx.stage.Stage;

// --------------------------------------------------------------------
// Test image
// --------------------------------------------------------------------
def n1:ImageView = ImageView
{	id: "Image1";
	image: Image { url: "{__DIR__}TCFscan_medium.jpg"; }
}
def n2 = createSceneGraphA(n1.layoutBounds.width,n1.layoutBounds.height);
def n3:ImageView = ImageView
{	id: "Image2";
	image: Image { url: "{__DIR__}VC.jpg"; }
}
def n4 = createSceneGraphB(n1.layoutBounds.width,n1.layoutBounds.height);

// Create a list of nodes to cycle through
def nodeList = [n1,n2,n3,n4];
var nextNode:Integer = 1;

// --------------------------------------------------------------------
// Wipes
// --------------------------------------------------------------------
def wipeNames:String[] = 
[	"Fade","FadeOut","Slide","SlideOver","Reveal 1","Reveal 2","Flip180",
	"SwingInOut 1","SwingInOut 2","SwingInOut 3","ShapeWipe","BlindWipe 1",
	"BlindWipe 2",/*"FadeReveal",*/"FadeZoom"
];
def wipeTypes:Wipe[] = 
[	FadeWipe
	{	time: 1s;
	} ,
	FadeOutWipe
	{	time: 1s;
	} ,
	SlideWipe
	{	time: 1s;
		direction: SlideWipe.BOTTOM_TO_TOP;
	} ,
	SlideOverWipe
	{	time: 1s;
		direction: SlideOverWipe.LEFT_TO_RIGHT;
	} ,
	RevealWipe
	{	time: 1s;
		direction: RevealWipe.LEFT_TO_RIGHT;
	} ,
	RevealWipe
	{	time: 1s;
		direction: RevealWipe.TOP_RIGHT;
	} ,
	Flip180Wipe
	{	time: 1s;
		direction: Flip180Wipe.LEFT_TO_RIGHT;
	} ,
	SwingInOutWipe
	{	time: 1s;
		anchor: SwingInOutWipe.TOP;
		direction: SwingInOutWipe.OUT;
	} ,
	SwingInOutWipe
	{	time: 1s;
		anchor: SwingInOutWipe.RIGHT;
		direction: SwingInOutWipe.IN;
	} ,
	SwingInOutWipe
	{	time: 1s;
		anchor: SwingInOutWipe.TOP_RIGHT;
		direction: SwingInOutWipe.IN;
	} ,
	ShapeWipe
	{	time: 1s;
		direction: ShapeWipe.IN;
		shape: javafx.scene.shape.Circle
		{	radius: n1.layoutBounds.width*0.75;
			layoutX: n1.layoutBounds.width/2;
			layoutY: n1.layoutBounds.height/2;
		}
	} ,
	BlindWipe
	{	time: 1s;
		direction: BlindWipe.RIGHT_TO_LEFT;
		blinds: 5;
	} ,
	BlindWipe
	{	time: 1s;
		direction: BlindWipe.TOP_TO_BOTTOM;
		blinds: 10;
	} ,
	/*FadeRevealWipe
	{	time: 1s;
		direction: FadeRevealWipe.LEFT_TO_RIGHT;
	} ,*/
	FadeZoomWipe
	{	time: 1s;
	}
];
var currentWipe:Integer = 0;
var enableWipe:Boolean = true;


// --------------------------------------------------------------------
// Control panel
// --------------------------------------------------------------------
def pan:Flow = Flow
{	layoutX: 10;
	layoutY: n1.layoutBounds.height+10;
	hgap: 10;
	content:
	[	Button
		{	text: "<<";
			action: function()
			{	var a = currentWipe-1;
				if(a<0) a = (sizeof wipeTypes)-1;
				currentWipe = a;
			}
		},
		Label
		{	text: bind wipeNames[currentWipe];
			layoutInfo: javafx.scene.layout.LayoutInfo
			{	width: 100;
			}
		} ,
		Button
		{	text: ">>";
			action: function()
			{	currentWipe = (currentWipe+1) mod (sizeof wipeTypes);
			}
		} ,
		Button
		{	text: "Wipe";
			disable: bind not enableWipe;
			action: function()
			{	//enableWipe=false; // Wipes are now interruptable
				wiper.next
				(	//if(wiper.content[0]==n1) n2 else n1
					nodeList[nextNode]
				);
				nextNode = (nextNode+1) mod sizeof nodeList;
			}
		}		
	]
}

// --------------------------------------------------------------------
// Build scene graph
// --------------------------------------------------------------------
var wiper:XWipePanel;
var sc:Scene;
Stage
{	scene: sc = Scene
	{	content:
		[	wiper = XWipePanel
			{	content: [ n1 ]
				wipe: bind wipeTypes[currentWipe];
				action: function() { enableWipe=true; }
			} ,
			pan
		]
	}
	title: "Wipe test";
	resizable: false;

	extensions:
	[	javafx.stage.AppletStageExtension
		{	shouldDragStart: function(e: javafx.scene.input.MouseEvent): Boolean
			{	return e.shiftDown and e.primaryButtonDown;
			}
			useDefaultClose: true;
		}
	];
}

// --------------------------------------------------------------------
// Build test node
// --------------------------------------------------------------------
function createSceneGraphA(w:Number,h:Number) : Node
{	var c:javafx.scene.shape.Circle;
	var r:javafx.scene.shape.Rectangle;
	def g = Group
	{	id: "Graph1";
		content:
		[	javafx.scene.shape.Rectangle
			{	width: w;  height: h;
				fill: LinearGradient
				{	proportional:false;  endY:h;  
					stops:
					[	Stop { offset: 0;  color: Color.LIGHTYELLOW; } ,
						Stop { offset: 1;  color: Color.SKYBLUE; }
					]
				}
				cache: true;
			}
			r = javafx.scene.shape.Rectangle
			{	x:250;  y:100;
				width: 200;  height: 200;
				fill: Color.ORANGE;
			} ,
			c = javafx.scene.shape.Circle
			{	radius: 100;
				layoutX: 200;  layoutY: 125;
				fill: RadialGradient
				{	proportional:false;  centerX: 0;  centerY: -25;  
					radius: 100;
					stops:
					[	Stop { offset: 0;  color: Color.YELLOW; } ,
						Stop { offset: 0.5;  color: Color.LIMEGREEN; } ,
						Stop { offset: 1;  color: Color.GREEN; }
					]
				}
				cache: true;
			}
		]
	}
	javafx.animation.transition.TranslateTransition
	{	node: c;
		duration: 1s;
		autoReverse: true;
		repeatCount:
			javafx.animation.transition.TranslateTransition.INDEFINITE;
		byX: 150;  byY: 150;
	}.play();
	javafx.animation.transition.RotateTransition
	{	node: r;
		duration: 1.5s;
		autoReverse: true;
		repeatCount:
			javafx.animation.transition.TranslateTransition.INDEFINITE;
		byAngle: 360;
	}.play();
	g;
}
// --------------------------------------------------------------------
// Build test node
// --------------------------------------------------------------------
function createSceneGraphB(w:Number,h:Number) : Node
{	def l:Label = Label
	{	text: "Press a button";
		textFill: Color.WHITE;
	}
	Stack
	{	content:
		[	javafx.scene.shape.Rectangle
			{	width: w;  height: h;
				fill: LinearGradient
				{	proportional: false;
					endX: 0;  endY: h;
					stops:
					[	Stop { offset: 0;  color: Color.SLATEGREY; } ,
						Stop { offset: 1;  color: Color.BLACK; }
					]
				}
			} ,
			VBox
			{	spacing:  10;
				hpos: javafx.geometry.HPos.CENTER;
				vpos: javafx.geometry.VPos.CENTER;
				content:
				[	for(i in [1..5])
					{	Button
						{	text: "Button {i}"
							action: function() { l.text = "Button {i}"; }
						}
					} ,
					l
				]
			}
		]
	}
}