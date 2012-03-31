package persil.core.context;

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

		context = null;
		instance = null;
	}
}