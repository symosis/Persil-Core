package persil.core.context;

class DefaultDynamicObject implements DynamicObject
{
	public var context : Context;
	public var contextObject : ContextObject;
	public var instance : Dynamic;

	public function new() {}

	public function remove() : Void
	{
		context.objects.remove(contextObject);

		context = null;
		instance = null;
	}
}