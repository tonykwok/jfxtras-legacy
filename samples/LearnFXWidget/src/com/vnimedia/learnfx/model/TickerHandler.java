/*
 * Tickerhandler.fx - A JavaFX Script example program that demonstrates
 * a progress bar displaying the progress of an asynchronous task.
 *
 * Developed 2009 by James L. Weaver jim.weaver [at] javafxpert.com
 * as a JavaFX Script SDK 1.2 example for the Pro JavaFX book.
 */

//TODO: Is this interface necessary or is there a built-in way?
//TODO: What is the purpose for Task#taskCallbackHandler?

package com.vnimedia.learnfx.model;

public interface TickerHandler {
  void onTick();
}
