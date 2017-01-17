/*
 * Ticker.java - A Java class used in a JavaFX Script example program that
 * demonstrates a progress bar displaying the progress of an asynchronous task.
 *
 * Developed 2009 by James L. Weaver jim.weaver [at] javafxpert.com
 * as a JavaFX Script SDK 1.2 example for the Pro JavaFX book.
 */

package com.vnimedia.learnfx.model;

import com.sun.javafx.functions.Function0;
import javafx.lang.FX;
import javafx.async.RunnableFuture;

public class Ticker implements RunnableFuture {
  TickerHandler tickerHandler;

  public Ticker (TickerHandler tickerHandler) {
    this.tickerHandler = tickerHandler;
  }

  @Override public void run() {
    while (true) {
      if (tickerHandler != null) {
        FX.deferAction(new Function0<Void>() {
           public Void invoke() {
             tickerHandler.onTick();
             return null;
           }
        });
      }
      try {
        //TODO: Make this configurable
        Thread.sleep(60000);
      }
      catch (InterruptedException te) {}
    }
  }
}
