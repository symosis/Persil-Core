package persil.core.processor;

import persil.core.context.Context;
import persil.core.context.ContextObject;

interface LifecycleProcessor 
{
	function process(context : Context) : Void;

	function processSingleObject(context : Context, contextObject: ContextObject) : Void;
}