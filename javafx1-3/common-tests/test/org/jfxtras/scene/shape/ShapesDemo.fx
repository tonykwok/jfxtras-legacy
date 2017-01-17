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

package org.jfxtras.scene.shape;

import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.Stop;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.shape.Rectangle;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.Group;
import javafx.scene.text.Text;
import javafx.scene.text.Font;
import javafx.scene.text.TextOrigin;
import javafx.scene.paint.LinearGradient;
import javafx.scene.effect.Glow;
import javafx.scene.transform.Rotate;

/**
 * @author Andres Almiray
 * @author Dean Iverson
 */

var drawAlmonds = [
    Almond {
        centerX: 60
        centerY: 60
        width: 60
        fill: Color.RED
        stroke: Color.BLACK
    },
    Almond {
        centerX: 180
        centerY: 60
        width: 20
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Almond {
        centerX: 60
        centerY: 180
        width: 40
        transforms :  [ Rotate { angle:  -90  pivotX: 60 pivotY: 180 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Almond {
        centerX: 180
        centerY: 180
        width: 40
        transforms :  [ Rotate { angle:  90  pivotX: 180 pivotY: 180 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Almond {
        centerX: 60
        centerY: 280
        width: 60
        transforms :  [ Rotate { angle:  -45  pivotX: 60 pivotY: 280 } ];
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Almond {
        centerX: 180
        centerY: 280
        width: 60
        transforms :  [ Rotate { angle:  45  pivotX: 180 pivotY: 280 } ];
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var drawArrows = [
    Arrow {
        x: 20
        y: 20
        width: 100
        height: 60
        rise: 0.5
        depth: 0.5
        fill: Color.RED
        stroke: Color.BLACK
    },
    Arrow {
        x: 140
        y: 20
        width: 100
        height: 60
        rise: 0.5
        depth: 0.2
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Arrow {
        x: 20
        y: 100
        width: 100
        height: 60
        rise: 0.75
        depth: 0.5
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Arrow {
        x: 140
        y: 100
        width: 100
        height: 60
        rise: 0.25
        depth: 0.5
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Arrow {
        x: 20
        y: 200
        width: 100
        height: 60
        rise: 0.5
        depth: 0.5
        rotate: 45
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Arrow {
        x: 140
        y: 200
        width: 100
        height: 60
        rise: 0.5
        depth: 0.5
        rotate: 180
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var drawAsterisks = [
    Asterisk {
        centerX: 60
        centerY: 60
        radius: 40
        width: 10
        beams: 4
        fill: Color.RED
        stroke: Color.BLACK
    },
    Asterisk {
        centerX: 160
        centerY: 60
        radius: 40
        width: 10
        beams: 5
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Asterisk {
        centerX: 60
        centerY: 160
        radius: 40
        width: 10
        roundness: 0.25
        beams: 6
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Asterisk {
        centerX: 160
        centerY: 160
        radius: 40
        width: 5
        beams: 7
        roundness: 0.75
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Asterisk {
        centerX: 60
        centerY: 260
        radius: 40
        width: 5
        rotate: 45
        beams: 8
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Asterisk {
        centerX: 160
        centerY: 260
        radius: 40
        width: 5
        rotate: 45
        roundness: 0.5
        beams: 8
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var drawAstroids = [
    Astroid {
        centerX: 60
        centerY: 60
        radius: 40
        fill: Color.RED
        stroke: Color.BLACK
    },
    Astroid {
        centerX: 220
        centerY: 60
        radius: 50
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Astroid {
        centerX: 60
        centerY: 220
        radius: 60
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Astroid {
        centerX: 220
        centerY: 220
        radius: 80
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawBalloons = [
    Balloon {
        x: 20
        y: 20
        width: 50
        height: 50
        arc: 0
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_BOTTOM
        anglePosition: Balloon.NONE
        fill: Color.RED
        stroke: Color.BLACK
    },
    Balloon {
        x: 90
        y: 20
        width: 50
        height: 50
        arc: 0
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_LEFT
        anglePosition: Balloon.NONE
        fill: Color.RED
        stroke: Color.BLACK
    },
    Balloon {
        x: 160
        y: 20
        width: 50
        height: 50
        arc: 0
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_TOP
        anglePosition: Balloon.NONE
        fill: Color.RED
        stroke: Color.BLACK
    },
    Balloon {
        x: 230
        y: 20
        width: 50
        height: 50
        arc: 0
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_RIGHT
        anglePosition: Balloon.NONE
        fill: Color.RED
        stroke: Color.BLACK
    },

    Balloon {
        x: 20
        y: 90
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_BOTTOM
        anglePosition: Balloon.ANGLE_AT_END
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Balloon {
        x: 90
        y: 90
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_LEFT
        anglePosition: Balloon.ANGLE_AT_END
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Balloon {
        x: 160
        y: 90
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_TOP
        anglePosition: Balloon.ANGLE_AT_END
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Balloon {
        x: 230
        y: 90
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_RIGHT
        anglePosition: Balloon.ANGLE_AT_END
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    Balloon {
        x: 20
        y: 160
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_BOTTOM
        anglePosition: Balloon.ANGLE_AT_START
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Balloon {
        x: 90
        y: 160
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_LEFT
        anglePosition: Balloon.ANGLE_AT_START
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Balloon {
        x: 160
        y: 160
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_TOP
        anglePosition: Balloon.ANGLE_AT_START
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Balloon {
        x: 230
        y: 160
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0.5
        tabLocation: Balloon.TAB_AT_RIGHT
        anglePosition: Balloon.ANGLE_AT_START
        fill: Color.BLUE
        stroke: Color.BLACK
    },

    Balloon {
        x: 20
        y: 230
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0
        tabLocation: Balloon.TAB_AT_BOTTOM
        anglePosition: Balloon.NONE
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Balloon {
        x: 90
        y: 230
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0
        tabLocation: Balloon.TAB_AT_LEFT
        anglePosition: Balloon.NONE
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Balloon {
        x: 160
        y: 230
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0
        tabLocation: Balloon.TAB_AT_TOP
        anglePosition: Balloon.NONE
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Balloon {
        x: 230
        y: 230
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 0
        tabLocation: Balloon.TAB_AT_RIGHT
        anglePosition: Balloon.NONE
        fill: Color.ORANGE
        stroke: Color.BLACK
    },

    Balloon {
        x: 20
        y: 300
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 1
        tabLocation: Balloon.TAB_AT_BOTTOM
        anglePosition: Balloon.NONE
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Balloon {
        x: 90
        y: 300
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 1
        tabLocation: Balloon.TAB_AT_LEFT
        anglePosition: Balloon.NONE
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Balloon {
        x: 160
        y: 300
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 1
        tabLocation: Balloon.TAB_AT_TOP
        anglePosition: Balloon.NONE
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Balloon {
        x: 230
        y: 300
        width: 50
        height: 50
        arc: 10
        tabWidth: 20
        tabHeight: 10
        tabDisplacement: 1
        tabLocation: Balloon.TAB_AT_RIGHT
        anglePosition: Balloon.NONE
        fill: Color.MAGENTA
        stroke: Color.BLACK
    }
];

var drawCrosses = [
    Cross {
        centerX: 60
        centerY: 60
        radius: 40
        width: 30
        fill: Color.RED
        stroke: Color.BLACK
    },
    Cross {
        centerX: 160
        centerY: 60
        radius: 40
        width: 10
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Cross {
        centerX: 60
        centerY: 160
        radius: 40
        width: 30
        roundness: 0.25
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Cross {
        centerX: 160
        centerY: 160
        radius: 40
        width: 30
        roundness: 0.75
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Cross {
        centerX: 60
        centerY: 260
        radius: 40
        width: 30
        rotate: 45
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Cross {
        centerX: 160
        centerY: 260
        radius: 40
        width: 30
        rotate: 45
        roundness: 0.5
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var drawDonuts = [
    Donut {
        centerX: 40
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        sides: 0
        fill: Color.RED
        stroke: Color.BLACK
    },
    Donut {
        centerX: 120
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        sides: 3
        fill: Color.RED
        stroke: Color.BLACK
    },
    Donut {
        centerX: 200
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        sides: 4
        fill: Color.RED
        stroke: Color.BLACK
    },
    Donut {
        centerX: 280
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        sides: 5
        fill: Color.RED
        stroke: Color.BLACK
    },

    Donut {
        centerX: 40
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        sides: 0
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Donut {
        centerX: 120
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        sides: 3
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Donut {
        centerX: 200
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        sides: 4
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Donut {
        centerX: 280
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        sides: 5
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    Donut {
        centerX: 40
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        sides: 0
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 120
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        sides: 3
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 200
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        sides: 4
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 280
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        sides: 5
        fill: Color.BLUE
        stroke: Color.BLACK
    },

    Donut {
        centerX: 40
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        sides: 2
        transforms :  [ Rotate { angle:  45  pivotX: 40 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 120
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        sides: 3
        transforms :  [ Rotate { angle:  45  pivotX: 120 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 200
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        sides: 4
        transforms :  [ Rotate { angle:  45  pivotX: 200 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Donut {
        centerX: 280
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        sides: 5
        transforms :  [ Rotate { angle:  45  pivotX: 280 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawLauburus = [
    Lauburu {
        centerX: 60
        centerY: 60
        radius: 30
        fill: Color.RED
        stroke: Color.BLACK
    },
    Lauburu {
        centerX: 180
        centerY: 60
        radius: 10
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Lauburu {
        centerX: 60
        centerY: 180
        radius: 20
        rotate: -90
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Lauburu {
        centerX: 180
        centerY: 180
        radius: 20
        rotate: 90
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Lauburu {
        centerX: 60
        centerY: 280
        radius: 50
        rotate: -45
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Lauburu {
        centerX: 180
        centerY: 280
        radius: 50
        rotate: 45
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var drawMultiRoundRectangles = [
    MultiRoundRectangle {
        x: 20
        y: 20
        width: 120
        height: 60
        topLeftWidth: 30
        topLeftHeight: 30
        topRightWidth: 30
        topRightHeight: 30
        bottomLeftWidth: 0
        bottomLeftHeight: 0
        bottomRightWidth: 0
        bottomRightHeight: 0
        fill: Color.RED
        stroke: Color.BLACK
    },
    MultiRoundRectangle {
        x: 160
        y: 20
        width: 120
        height: 60
        topLeftWidth: 0
        topLeftHeight: 0
        topRightWidth: 0
        topRightHeight: 0
        bottomLeftWidth: 30
        bottomLeftHeight: 30
        bottomRightWidth: 30
        bottomRightHeight: 30
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    MultiRoundRectangle {
        x: 20
        y: 100
        width: 120
        height: 60
        topLeftWidth: 30
        topLeftHeight: 30
        topRightWidth: 0
        topRightHeight: 0
        bottomLeftWidth: 30
        bottomLeftHeight: 30
        bottomRightWidth: 0
        bottomRightHeight: 0
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    MultiRoundRectangle {
        x: 160
        y: 100
        width: 120
        height: 60
        topLeftWidth: 0
        topLeftHeight: 0
        topRightWidth: 30
        topRightHeight: 30
        bottomLeftWidth: 0
        bottomLeftHeight: 0
        bottomRightWidth: 30
        bottomRightHeight: 30
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawRays = [
    Rays {
        centerX: 40
        centerY: 40
        radius: 30
        rays: 2
        extent: 0.5
        fill: Color.RED
        stroke: Color.BLACK
    },
    Rays {
        centerX: 120
        centerY: 40
        radius: 30
        rays: 3
        extent: 0.5
        fill: Color.RED
        stroke: Color.BLACK
    },
    Rays {
        centerX: 200
        centerY: 40
        radius: 30
        rays: 4
        extent: 0.5
        fill: Color.RED
        stroke: Color.BLACK
    },
    Rays {
        centerX: 280
        centerY: 40
        radius: 30
        rays: 5
        extent: 0.5
        fill: Color.RED
        stroke: Color.BLACK
    },

    Rays {
        centerX: 40
        centerY: 120
        radius: 30
        rays: 2
        extent: 0.25
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Rays {
        centerX: 120
        centerY: 120
        radius: 30
        rays: 3
        extent: 0.25
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Rays {
        centerX: 200
        centerY: 120
        radius: 30
        rays: 4
        extent: 0.25
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Rays {
        centerX: 280
        centerY: 120
        radius: 30
        rays: 5
        extent: 0.25
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    Rays {
        centerX: 40
        centerY: 200
        radius: 30
        rays: 2
        extent: 0.75
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 120
        centerY: 200
        radius: 30
        rays: 3
        extent: 0.75
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 200
        centerY: 200
        radius: 30
        rays: 4
        extent: 0.75
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 280
        centerY: 200
        radius: 30
        rays: 5
        extent: 0.75
        fill: Color.BLUE
        stroke: Color.BLACK
    },

    Rays {
        centerX: 40
        centerY: 280
        radius: 30
        rays: 2
        extent: 0.5
        rounded: true
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 120
        centerY: 280
        radius: 30
        rays: 3
        extent: 0.5
        rounded: true
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 200
        centerY: 280
        radius: 30
        rays: 4
        extent: 0.5
        rounded: true
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Rays {
        centerX: 280
        centerY: 280
        radius: 30
        rays: 5
        extent: 0.5
        rounded: true
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawRegularPolygons = [
    RegularPolygon {
        centerX: 40
        centerY: 40
        radius: 30
        sides: 3
        fill: Color.RED
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 120
        centerY: 40
        radius: 30
        sides: 4
        fill: Color.RED
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 200
        centerY: 40
        radius: 30
        sides: 5
        fill: Color.RED
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 280
        centerY: 40
        radius: 30
        sides: 6
        fill: Color.RED
        stroke: Color.BLACK
    },

    RegularPolygon {
        centerX: 40
        centerY: 120
        radius: 30
        sides: 3
        transforms :  [ Rotate { angle:  45  pivotX: 40 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 120
        centerY: 120
        radius: 30
        sides: 4
        transforms :  [ Rotate { angle:  45  pivotX: 120 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 200
        centerY: 120
        radius: 30
        sides: 5
        transforms :  [ Rotate { angle:  45  pivotX: 200 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 280
        centerY: 120
        radius: 30
        sides: 6
        transforms :  [ Rotate { angle:  45  pivotX: 280 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    RegularPolygon {
        centerX: 40
        centerY: 200
        radius: 30
        sides: 3
        transforms :  [ Rotate { angle:  115  pivotX: 40 pivotY: 200 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 120
        centerY: 200
        radius: 30
        sides: 4
        transforms :  [ Rotate { angle:  115  pivotX: 120 pivotY: 200 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 200
        centerY: 200
        radius: 30
        sides: 5
        transforms :  [ Rotate { angle:  115  pivotX: 200 pivotY: 200 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RegularPolygon {
        centerX: 280
        centerY: 200
        radius: 30
        sides: 6
        transforms :  [ Rotate { angle:  115  pivotX: 280 pivotY: 200 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    }
];

var drawReuleauxTriangles= [
    ReuleauxTriangle {
        centerX: 60
        centerY: 80
        radius: 30
        fill: Color.RED
        stroke: Color.BLACK
    },
    ReuleauxTriangle {
        centerX: 220
        centerY: 80
        radius: 40
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    ReuleauxTriangle {
        centerX: 60
        centerY: 240
        radius: 50
        transforms :  [ Rotate { angle:  -30  pivotX: 60 pivotY: 240 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    ReuleauxTriangle {
        centerX: 220
        centerY: 240
        radius: 50
        transforms :  [ Rotate { angle:  30  pivotX: 220 pivotY: 240 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawRoundPins = [
    RoundPin {
        centerX: 50
        centerY: 50
        radius: 20
        height: 40
        fill: Color.RED
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 120
        centerY: 50
        radius: 20
        height: 30
        fill: Color.RED
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 190
        centerY: 50
        radius: 20
        height: 20
        fill: Color.RED
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 260
        centerY: 50
        radius: 20
        height: 10
        fill: Color.RED
        stroke: Color.BLACK
    },

    RoundPin {
        centerX: 50
        centerY: 120
        radius: 20
        height: 40
        transforms :  [ Rotate { angle:  45  pivotX: 50 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 120
        centerY: 120
        radius: 20
        height: 30
        transforms :  [ Rotate { angle:  45  pivotX: 120 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 190
        centerY: 120
        radius: 20
        height: 20
        transforms :  [ Rotate { angle:  45  pivotX: 190 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 260
        centerY: 120
        radius: 20
        height: 10
        transforms :  [ Rotate { angle:  45  pivotX: 260 pivotY: 120 } ];
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    RoundPin {
        centerX: 50
        centerY: 190
        radius: 20
        height: 40
        transforms :  [ Rotate { angle:  90  pivotX: 50 pivotY: 190 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 120
        centerY: 190
        radius: 20
        height: 30
        transforms :  [ Rotate { angle:  90  pivotX: 120 pivotY: 190 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 190
        centerY: 190
        radius: 20
        height: 20
        transforms :  [ Rotate { angle:  90  pivotX: 190 pivotY: 190 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    RoundPin {
        centerX: 260
        centerY: 190
        radius: 20
        height: 10
        transforms :  [ Rotate { angle:  90  pivotX: 260 pivotY: 190 } ];
        fill: Color.BLUE
        stroke: Color.BLACK
    },
];

var drawStars = [
    Star2 {
        centerX: 40
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        count: 2
        fill: Color.RED
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 120
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        count: 3
        fill: Color.RED
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 200
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        count: 4
        fill: Color.RED
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 280
        centerY: 40
        outerRadius: 30
        innerRadius: 5
        count: 5
        fill: Color.RED
        stroke: Color.BLACK
    },

    Star2 {
        centerX: 40
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        count: 2
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 120
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        count: 3
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 200
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        count: 4
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 280
        centerY: 120
        outerRadius: 30
        innerRadius: 10
        count: 5
        fill: Color.GREEN
        stroke: Color.BLACK
    },

    Star2 {
        centerX: 40
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        count: 2
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 120
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        count: 3
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 200
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        count: 4
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 280
        centerY: 200
        outerRadius: 30
        innerRadius: 20
        count: 5
        fill: Color.BLUE
        stroke: Color.BLACK
    },

    Star2 {
        centerX: 40
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        count: 2
        transforms :  [ Rotate { angle:  45  pivotX: 40 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 120
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        count: 3
        transforms :  [ Rotate { angle:  45  pivotX: 120 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 200
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        count: 4
        transforms :  [ Rotate { angle:  45  pivotX: 200 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Star2 {
        centerX: 280
        centerY: 280
        outerRadius: 30
        innerRadius: 10
        count: 5
        transforms :  [ Rotate { angle:  45  pivotX: 280 pivotY: 280 } ];
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
];

var drawTriangles = [
    ETriangle {
        x: 20,
        y: 90,
        width: 80
        rotate: 0
        fill: Color.RED
        stroke: Color.BLACK
    },
    ETriangle {
        x: 140,
        y: 90,
        width: 80
        rotate: 45
        fill: Color.RED
        stroke: Color.BLACK
    },
    ETriangle {
        x: 260,
        y: 90,
        width: 80
        rotate: 90
        fill: Color.RED
        stroke: Color.BLACK
    },

    ITriangle {
        x: 20,
        y: 190,
        width: 80
        rotate: 0
        height: 30
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    ITriangle {
        x: 140,
        y: 190,
        width: 80
        rotate: 45
        height: 30
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    ITriangle {
        x: 260,
        y: 190,
        width: 80
        rotate: 90
        height: 30
        fill: Color.BLUE
        stroke: Color.BLACK
    },

    RTriangle {
        x: 20,
        y: 300,
        width: 80
        rotate: 0
        height: 30
        anglePosition: RTriangle.ANGLE_AT_END
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    RTriangle {
        x: 140,
        y: 300,
        width: 80
        rotate: 45
        height: 30
        anglePosition: RTriangle.ANGLE_AT_END
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    RTriangle {
        x: 260,
        y: 300,
        width: 80
        rotate: 90
        height: 30
        anglePosition: RTriangle.ANGLE_AT_END
        fill: Color.ORANGE
        stroke: Color.BLACK
    }
];

var drawGears = [
    Gear {
        centerX: 60
        centerY: 60
        outerRadius: 40
        innerRadius: 28
        teeth: 4
        fill: Color.RED
        stroke: Color.BLACK
    },
    Gear {
        centerX: 160
        centerY: 60
        outerRadius: 40
        innerRadius: 32
        teeth: 5
        fill: Color.GREEN
        stroke: Color.BLACK
    },
    Gear {
        centerX: 60
        centerY: 160
        outerRadius: 40
        innerRadius: 28
        teeth: 6
        toothRatio:0.8
        toothTaperRatio:1.2
        fill: Color.BLUE
        stroke: Color.BLACK
    },
    Gear {
        centerX: 160
        centerY: 160
        outerRadius: 40
        innerRadius: 32
        teeth: 7
        toothRatio:1.3
        toothTaperRatio:0.8
        fill: Color.ORANGE
        stroke: Color.BLACK
    },
    Gear {
        centerX: 60
        centerY: 260
        outerRadius: 40
        innerRadius: 25
        toothRatio:2.0
        toothTaperRatio:1.0
        fill: Color.MAGENTA
        stroke: Color.BLACK
    },
    Gear {
        centerX: 160
        centerY: 260
        outerRadius: 40
        innerRadius: 30
        teeth: 8
        toothRatio:0.8
        toothTaperRatio:1.2
        fill: Color.CYAN
        stroke: Color.BLACK
    }
];

var sceneContent:Node[] = drawAlmonds;

function createButton(text:String, nodes:Node[]): Node {
    Group {
        def lightingEffect = Glow {}
        def r:Rectangle = Rectangle {
            width: 175
            height: 30
            arcHeight: 10
            arcWidth: 10
            smooth: true
            stroke: Color.DIMGRAY
            fill: LinearGradient {
                endX: 0.0
                endY: 1.0
                stops: [
                    Stop { offset: 0.0 color: Color.NAVAJOWHITE },
                    Stop { offset: 1.0 color: Color.OLIVE },
                ]
            }
            onMouseEntered: function( me:MouseEvent ) {
                sceneContent = nodes;
                r.effect = lightingEffect;
            }
            onMouseExited: function( me:MouseEvent ) {
                r.effect = null;
            }
        }
        def t:Text = Text {
            translateX: bind (r.width - t.layoutBounds.width) / 2 - t.layoutBounds.minX
            translateY: bind (r.height - t.layoutBounds.height) / 2 - t.layoutBounds.minY
            content: text
            fill: Color.BLACK;
            font: Font { size: 14 }
            textOrigin: TextOrigin.TOP
        }
        content: [ r, t ]
    }
}

Stage {
    title: "JFXtras Shapes Demo"
    scene: Scene {
        width: 550
        height: 630
        content: [
            HBox {
                translateX: 10
                translateY: 10
                content: [
                    VBox {
                        spacing: 5
                        content: [
                            createButton( "Almond", drawAlmonds ),
                            createButton( "Arrow", drawArrows ),
                            createButton( "Asterisk", drawAsterisks ),
                            createButton( "Astroid", drawAstroids ),
                            createButton( "Balloon", drawBalloons ),
                            createButton( "Cross", drawCrosses ),
                            createButton( "Donut", drawDonuts ),
                            createButton( "Lauburu", drawLauburus ),
                            createButton( "MultiRoundRectangle", drawMultiRoundRectangles ),
                            createButton( "Rays", drawRays ),
                            createButton( "RegularPolygon", drawRegularPolygons ),
                            createButton( "ReuleauxTriangle", drawReuleauxTriangles ),
                            createButton( "RoundPin", drawRoundPins ),
                            createButton( "Star2", drawStars ),
                            createButton( "Triangle", drawTriangles ),
                            createButton( "Gear", drawGears)
                        ]
                    },
                    Group {
                        content: bind sceneContent
                    }
                ]
            }
        ]
    }
}


