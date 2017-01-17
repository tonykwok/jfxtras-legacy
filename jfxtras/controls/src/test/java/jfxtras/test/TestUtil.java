package jfxtras.test;

import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

/**
 * A simple class that offers some methods for testing
 * @author Tom Eugelink
 *
 */
public class TestUtil
{
	/**
	 * setup the logging
	 */
	static private void setupLogging()
	{
		// scan all handlers and see if our is already present
		Logger lLogger = Logger.getLogger("");
		Handler[] lHandlers = lLogger.getHandlers();
		boolean lPresent = false;
		for (int i = 0; i < lHandlers.length && lPresent == false ;i++)
		{
			if (lHandlers[i] == cConsoleHandler) lPresent = true;
		}
		
		// if not present
	    if (lPresent == false) 
	    {
	    	// add a console handler
	    	cConsoleHandler = new ConsoleHandler()
	    	{
	    		{ setOutputStream( System.out ); } // output to stdout, it's just logging not errors
	    	};
	    	cConsoleHandler.setFormatter(new Formatter()
	    	{
				@Override
				public String format(LogRecord logRecord)
				{
					// one line per log item
					return logRecord.getSourceClassName() 
					     + " " 
					     + logRecord.getLevel() 
					     + " " 
					     + logRecord.getMessage() 
					     + "\n"; 
				}
	    	});
	    	cConsoleHandler.setLevel(Level.FINEST);
	    	lLogger.addHandler( cConsoleHandler );
	    }
	}
	private static ConsoleHandler cConsoleHandler = null;
	
	/**
	 * set the loglevel to the lowest value for a certain id
	 * @param clazz
	 * @param level
	 */
	static public void setLogLevelDebug(Class clazz)
	{
		setLogLevelDebug(clazz.getName());
	}
	
	/**
	 * set the loglevel to the lowest value for a certain class
	 * @param clazz
	 * @param level
	 */
	static public void setLogLevelDebug(String id)
	{
		setupLogging();
	    Logger.getLogger(id).setLevel(Level.FINEST);
	}
}
