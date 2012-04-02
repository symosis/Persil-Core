package persil.core.dynamicobject;

import persil.core.context.Context;
import persil.core.context.ContextObject;

import persil.core.util.ReflectUtil;

class DefaultDynamicObject implements DynamicObject
{
	public var instance : Dynamic;

	private var context : Context;
	private var contextObject : ContextObject;
	
	public function new(context : Context, contextObject : ContextObject) 
	{
		this.context = context;
		this.contextObject = contextObject;
	}

	public function remove() : Void
	{
		context.objects.remove(contextObject);

		doDestroyCall(contextObject);		

		context = null;
		contextObject = null;
		instance = null;
	}

	function doDestroyCall(contextObject : ContextObject)
	{
		ReflectUtil.callMethodWithMetadata(contextObject.object, contextObject.type, "Destroy", []);
	}
}