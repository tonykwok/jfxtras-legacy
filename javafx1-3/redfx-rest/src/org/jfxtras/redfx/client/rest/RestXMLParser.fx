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
package org.jfxtras.redfx.client.rest;

import javafx.data.pull.PullParser;
import javafx.data.pull.Event;
import javafx.reflect.FXLocal;

/**
 * @author William Antônio
 */
public class RestXMLParser extends PullParser {
   
    var isRoot: Boolean = false;
    public-init var uri: String;
    public-init var clazz: String;
    public-init var callback: function(uri: String, obj: Object): Void;
    var ctx: FXLocal.Context = FXLocal.getContext();
    var clazzType = ctx.findClass(clazz);
    var baseClass = clazzType.getName();
    var className = baseClass.substring(baseClass.lastIndexOf(".") + 1);
    var obj = clazzType.allocate();
    var tempObject: FXLocal.ObjectValue;   
    var answer: Object[];
    override var documentType = "xml";
    override var onEvent =  function (evt: Event) {        
        if (evt.type == PullParser.END_DOCUMENT) {
          println ("[RedFX] RestXMLParser done parsing {uri}");
          if (RestService.cacheEnabled) {
              RestService.cache.putEntry(uri, RestService.cacheTimeout, answer);
          }
          callback(uri, answer);
          input.close();
        }
        if (evt.type == PullParser.START_ELEMENT) {
            if (evt.qname.name.toLowerCase() == className.toLowerCase()) {                
                tempObject = clazzType.allocate();                
                isRoot = true;
            }
        }
        if (evt.type == PullParser.END_ELEMENT and isRoot) {
           
                var index = (sizeof answer) - 1;                
                for (variable in clazzType.getVariables(true)) {
                    if (variable.getName() == evt.qname.name) {
                        var value: Object;
                            try {
                                var typeName = variable.getType().getName();
                                if (typeName == "java.lang.String") {
                                    value = evt.text;
                                } else if (typeName == "Integer") {
                                    if (evt.text.trim() == "") value = 0 else value = Integer.parseInt(evt.text.trim())
                                } else if (typeName == "Number" or typeName == "java.lang.Float" or typeName == "Float"){
                                    value = Float.parseFloat(evt.text.trim());
                                }else if(typeName == "Boolean"){
                                    value = Boolean.parseBoolean(evt.text);
                                }
                                tempObject.initVar(variable.getName(), ctx.mirrorOf(value));                                
                            } catch (exp) {
                                println("[RedFX] Problems with {evt.qname.name}. Not filled on index {index+1}, from {className}");                                
                            }
                    }
                    
                }
                if (evt.qname.name.toLowerCase() == className.toLowerCase()) {
                    try{
                        tempObject.initialize();                         
                        insert (tempObject as FXLocal.ObjectValue).asObject() into answer;
                    }catch(exp){
                        println("[RedFX] RestXMLParser error initializing Object: {exp}");
                    }
                    isRoot = false
                }
            }
    }
}
