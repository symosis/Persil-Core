package persil.core.context;

interface DynamicObject 
{
	var context : Context;
	var contextObject : ContextObject;
	var instance : Dynamic;

	function remove() : Void;
}