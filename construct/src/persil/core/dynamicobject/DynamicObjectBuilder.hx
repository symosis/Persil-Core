package persil.core.dynamicobject;

import persil.reflect.ClassInfo;

import persil.core.context.Context;
import persil.core.context.ContextObject;
import persil.core.dynamicobject.DynamicObject;
import persil.core.dynamicobject.DefaultDynamicObject;
import persil.core.extension.Extension;
import persil.core.util.ReflectUtil;

class DynamicObjectBuilder 
{
	var context : Context;

	function new() {}

	public static function newBuilder() : DynamicObjectBuilder
	{
		return new DynamicObjectBuilder();
	}

	public function withContext(context : Context) : DynamicObjectBuilder 
	{
		this.context = context;

		return this;
	}

	public function build(instance : Dynamic) : DynamicObject
	{
		var contextObject : ContextObject = configureDynamicObject(instance);

		var dynamicObject : DynamicObject = new DefaultDynamicObject(context, contextObject);
		dynamicObject.instance = instance;

		return dynamicObject;
	}

	function configureDynamicObject(object : Dynamic) : ContextObject
	{
		var contextObject = context.addObject("configured", ClassInfo.forInstance(object), object);
		
		context.config.lifecycleProcessor.processSingleObject(context, cast contextObject);

		return contextObject;
	}
}