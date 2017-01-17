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
package org.jfxtras.scene.control;

import javafx.scene.layout.LayoutInfo;
import javafx.stage.Stage;
import org.jfxtras.lang.XObject;
import org.jfxtras.scene.FPSMonitor;
import org.jfxtras.scene.XScene;
import org.jfxtras.scene.border.XEmptyBorder;
import org.jfxtras.scene.control.data.ObjectDataProvider;
import org.jfxtras.scene.control.data.MapDataProvider;
import org.jfxtras.util.XMap;

/**
 * @author Stephen Chin
 * @author Keith Combs
 */
class AnimeCharacter extends XObject {
    var index:Integer;
    var image:String;
    var name:String;
    var show:String;
    var hairColor:String;
    override function toString() {
        "AnimeCharacter \{name: {name}, show: {show}, hairColor: {hairColor}\}"
    }
}

var charList:AnimeCharacter[] = [
    AnimeCharacter {image: "{__DIR__}TableImages/Ryoko.jpg", name: "Ryoko", show: "Tenchi Muyo", hairColor: "Blue"}
    AnimeCharacter {image: "{__DIR__}TableImages/Ayeka.jpg", name: "Ayeka", show: "Tenchi Muyo", hairColor: "Brown"}
    AnimeCharacter {image: "{__DIR__}TableImages/Sasami.jpg", name: "Sasami", show: "Tenchi Muyo", hairColor: "Blue"}
    AnimeCharacter {image: "{__DIR__}TableImages/Mihoshi.jpg", name: "Mihoshi", show: "Tenchi Muyo", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/SylviaStingray.jpg", name: "Sylvia Stingray", show: "Bubblegum Crisis", hairColor: "Silver"}
    AnimeCharacter {image: "{__DIR__}TableImages/Priss.jpg", name: "Priss", show: "Bubblegum Crisis", hairColor: "Brown"}
    AnimeCharacter {image: "{__DIR__}TableImages/Clare.jpg", name: "Clare", show: "Claymore", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/Teresa.jpg", name: "Teresa", show: "Claymore", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/Nagi.jpg", name: "Nagi", show: "Kannagi", hairColor: "Blue"}
    AnimeCharacter {image: "{__DIR__}TableImages/BlancNeige.jpg", name: "Blanc Neige", show: "Shining Wind", hairColor: "White"}
    AnimeCharacter {image: "{__DIR__}TableImages/Mao.jpg", name: "Mao", show: "Shining Wind", hairColor: "Red"}
    AnimeCharacter {image: "{__DIR__}TableImages/Kureha.jpg", name: "Kureha", show: "Shining Wind", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/FayeVallentine.jpg", name: "Faye Vallentine", show: "Cowboy Bebop", hairColor: "Brown"}
    AnimeCharacter {image: "{__DIR__}TableImages/Julia.jpg", name: "Julia", show: "Cowboy Bebop", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/Canaan.jpg", name: "Canaan", show: "Canaan", hairColor: "White"}
    AnimeCharacter {image: "{__DIR__}TableImages/Hazuki.jpg", name: "Hazuki", show: "Yami To Boushi", hairColor: "Black"}
    AnimeCharacter {image: "{__DIR__}TableImages/Hatsumi.jpg", name: "Hatsumi", show: "Yami To Boushi", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/Lilith.jpg", name: "Lilith", show: "Yami To Boushi", hairColor: "Blonde"}
    AnimeCharacter {image: "{__DIR__}TableImages/Jo.jpg", name: "Jo", show: "Bakuretsu Tenshi", hairColor: "White"}
    AnimeCharacter {image: "{__DIR__}TableImages/Meg.jpg", name: "Meg", show: "Bakuretsu Tenshi", hairColor: "Brown"}
];

def table:XTableView = XTableView {
    dataProvider: MapDataProvider {
        data: for (char in charList) XMap {
            entries: [
                XMap.Entry {
                    key: "image"
                    value: char.image
                }
                XMap.Entry {
                    key: "name"
                    value: char.name
                }
                XMap.Entry {
                    key: "show"
                    value: char.show
                }
                XMap.Entry {
                    key: "hairColor"
                    value: char.hairColor
                }
            ]
        }
    }
    rowHeight: 60
    onMouseClicked: function(e) {
        if (e.clickCount == 2) {
            println("selected = {(table.dataProvider as ObjectDataProvider).getItem(table.selectedRow)}");
        }
    }
    layoutInfo: LayoutInfo {width: 500}
}

function createColumns(columns:XTableColumn[]) {
    println("re-evaluating columns {columns}");
    
}

Stage {
    title: "JFXtras XTable Demo"
    scene: XScene {
        content: [
            FPSMonitor {
                node: XEmptyBorder {
                    borderWidth: 15
                    node: table
                }
            }
        ]
    }
}
