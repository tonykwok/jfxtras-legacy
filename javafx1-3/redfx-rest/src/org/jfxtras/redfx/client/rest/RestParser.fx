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
import javafx.reflect.FXVarMember;
import java.util.LinkedList;
import javafx.reflect.FXClassType;
import javafx.reflect.FXType;
import javafx.data.pull.PullParser;
import javafx.reflect.FXLocal;
import javafx.reflect.FXSequenceType;
import java.lang.Exception;
import java.util.NoSuchElementException;
import javafx.reflect.FXLocal.ObjectValue;
import javafx.reflect.FXSequenceValue;
import javafx.reflect.FXValue;

/**
 * @author johan
 */
public class RestParser extends PullParser {

  public-init var uri: String;
  public-init var clazz: String;
  public-init var callback: function(uri: String, obj: Object): Void;
  var ctx: FXLocal.Context = FXLocal.getContext();
  var clazzType: FXLocal.ClassType = ctx.findClass(clazz);
  var rootObject: FXLocal.ObjectValue = clazzType.allocate();
  //var arrayElements: ObjectValue[];
  var isList: Boolean = false;
  var answer: Object[];
  var current: FXLocal.ObjectValue = clazzType.allocate();
  var objectlist: LinkedList = new LinkedList();
  var varlist: LinkedList = new LinkedList();
  var arrayvars: LinkedList = new LinkedList();
  var arraynames: LinkedList = new LinkedList();
  var arraytypes: LinkedList = new LinkedList();
  var clazzname: String = clazz;
  var nextvar: FXVarMember;
  override var documentType = "json";
  override var onEvent = function(evt: Event) {
            if (evt.type == PullParser.START_DOCUMENT) {
            }
            if (evt.type == PullParser.END_DOCUMENT) {
              println("[RedFX] RestParser done parsing {uri}");
              if (RestService.cacheEnabled) {
                if (isList) {
                  RestService.cache.putEntry(uri, RestService.cacheTimeout, answer);
                } else {
                  RestService.cache.putEntry(uri, RestService.cacheTimeout, rootObject);
                }
              }
              if (isList) {
                callback(uri, answer);
              } else {
                callback(uri, rootObject.initialize().asObject());
              }
            }
            if (evt.type == PullParser.START_VALUE) {
              var myname = evt.name;
              var ct: FXClassType = current.getClassType();
              var mymember: FXVarMember = ct.getVariable(myname);
              var ftype: FXType = mymember.getType();
              if (mymember.getType().isJfxType()) {
                var mn: String = mymember.getType().getName();
                if ((mn != "Boolean") and (mn != "Integer") and (mn != "Float") ) {
                  if (mymember.getType() instanceof FXSequenceType) {
                    var fst: FXSequenceType = mymember.getType() as FXSequenceType;
                    var clt: FXType = fst.getComponentType();
                    clazzname = clt.getName();
                  } else {
                    clazzname = mymember.getType().getName();
                  }
                  nextvar = mymember;
                }
              }

            } else if (evt.type == PullParser.START_ARRAY) {
              if (evt.level ==-1) {
                isList = true;
              }
              arraynames.addFirst(clazzname);
              var myname = evt.name;
              var ct: FXClassType = current.getClassType();
              var mymember: FXVarMember = ct.getVariable(myname);
              var myarrayelements = [];
              arrayvars.addFirst(myarrayelements);
              var ctype: FXClassType = ctx.findClass(clazzname);
              arraytypes.addFirst(ctype);
              var fxtype: FXType = ctype.getSequenceType();
            } else if (evt.type == PullParser.END_ARRAY) {
              arraynames.removeFirst();
              var mytype: FXType = arraytypes.removeFirst() as FXType;
              var myname = evt.name;
              var ct: FXClassType = current.getClassType();
              var mymember: FXVarMember = ct.getVariable(myname);
              var myarrayelementsArray = arrayvars.removeFirst();
              var myarrayelements: ObjectValue[] = myarrayelementsArray as ObjectValue[];
              for (ael in myarrayelements) {
                ael.initialize();
              }

              var svf: FXValue = ctx.makeSequenceValue(myarrayelements, sizeof myarrayelements, mytype);
              if (objectlist.size() > 0) {
                current = objectlist.getFirst() as FXLocal.ObjectValue;
                current.initVar(myname, svf);
              } else {
                isList = true;
                answer = [];
                for (ael in myarrayelements) {
                  insert ael.initialize().asObject() into answer;
                }

              }

            } else if (evt.type == PullParser.START_ARRAY_ELEMENT) {
              clazzname = arraynames.getFirst() as String;
           
            } else if (evt.type == PullParser.START_ELEMENT) {
              var newobj = ctx.findClass(clazzname).allocate();
              objectlist.addFirst(newobj);
              varlist.addFirst(nextvar);
              current = newobj;
            } else if (evt.type == PullParser.END_ELEMENT) {
              var oldvar: FXVarMember = varlist.removeFirst() as FXVarMember;
              var old: FXLocal.ObjectValue = objectlist.removeFirst() as FXLocal.ObjectValue;
              old.initialize();

              try {
                if (isList and (oldvar == null)) {
                  var arrayElements = arrayvars.removeFirst() as ObjectValue[];
                  insert old into arrayElements;
                  arrayvars.addFirst(arrayElements);
                  nextvar= null;
                }
                else if (oldvar.getType() instanceof FXSequenceType) {
                  var arrayElements = arrayvars.removeFirst() as ObjectValue[];
                  insert old into arrayElements;
                  arrayvars.addFirst(arrayElements);
                } else {
                  if (objectlist.size() == 0) {
                    rootObject = old;
                  } else {
                    current = objectlist.getFirst() as FXLocal.ObjectValue;
                     var name: String = oldvar.getName();
                    current.initVar(name, old);
                  }
                }
              } catch (ex: NoSuchElementException) {
                println("NO SUCH ELEMENT, LAST ONE?");
              }

            } else if (evt.type == PullParser.TEXT) {
              try {
                current.initVar(evt.name, ctx.mirrorOf(evt.text));
              } catch (ex: Exception) { println("couldn't find {evt.name}") } // unknown field
            } else if (evt.type == PullParser.INTEGER) {
              try {
                current.initVar(evt.name, ctx.mirrorOf(evt.integerValue as Integer));
              } catch (ex: Exception) { } // unknown field
            } else if (evt.type == PullParser.NUMBER) {
              try {
                current.initVar(evt.name, ctx.mirrorOf(evt.numberValue as Number));
              } catch (ex: Exception) {} // unknown field

            }
            else if ((evt.type == PullParser.FALSE) or (evt.type == PullParser.TRUE)) {
              try {
                current.initVar(evt.name, ctx.mirrorOf(evt.booleanValue));
              } catch (ex: Exception) { } // unknown field
            }

          }

/*
  function printobjectlist() {
    println("[OBJECTLIST]");
    for (candidate in objectlist) {
      var obv = candidate as FXLocal.ObjectValue;
      println("*** {obv.getClassType()}")

    }
    println("[ENDOBJECTLIST]");
  }
 function printvarlist() {
    println("[VARLIST]");
    for (candidate in varlist) {
      var obv = candidate as FXVarMember;
      println("+++ {obv.getName()}")
    }
    println("[ENDVARLIST]");
  }
*/
}
