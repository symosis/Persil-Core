package persil.core.context;

import persil.reflect.ClassInfo;

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
		var dynamicObject : DynamicObject = new DefaultDynamicObject();
		dynamicObject.instance = instance;
		dynamicObject.context = context;

		dynamicObject.contextObject = configureDynamicObject(instance);

		return dynamicObject;
	}

	function configureDynamicObject(object : Dynamic) : ContextObject
	{
		var contextObject = context.addObject("configured", ClassInfo.forInstance(object), object);
		
		configureDynamicObjects(cast contextObject);

		return contextObject;
	}

	function configureDynamicObjects(object : ContextObject)
	{
		wireContextObject(object);
		Lambda.iter(context.config.extensions, processExtension);
		doCompleteCall(object);
		doPostCompleteCall(object);
	}

	function wireContextObject(contextObject : ContextObject)
	{
		if (!contextObject.classInfo.hasRtti)
			Log.warn("No RTTI for: ", contextObject.name, contextObject.classInfo.name);

		for (property in contextObject.classInfo.properties)
		{
			if (property.hasMetadata("Inject"))
			{
				if (property.clazz == Context)
				{
					property.setValue(contextObject.object, context);
				}
				else
				{
					var objects = context.getDynamicObjectsByType(property.clazz);
					if (objects.length == 0)
					{
						Log.warn("Found [Inject] at object " + Type.getClassName(contextObject.type)+ "#" + property.name + " but could not find object to inject.");
					}
					else if (objects.length == 1)
					{
						property.setValue(contextObject.object, objects.first().object);				
					}
					else
					{
						var found = false;
						for(object in objects)
						{
							if (object.name == property.name)
							{
								property.setValue(contextObject.object, object.object);
								found = true;
								break;				
							}
						}
						if (!found)
							throw "Multiple selection for type: " + property.type.name + " and no name match for: " + property.name;
					}
				}
			}
		}
	}

	function processExtension(extension : Extension) : Void
	{
		extension.process(context);
	}
	
	function doCompleteCall(contextObject : ContextObject)
	{
		ReflectUtil.callMethodWithMetadata(contextObject.object, contextObject.type, "Complete", []);
	}

	function doPostCompleteCall(contextObject : ContextObject)
	{
		ReflectUtil.callMethodWithMetadata(contextObject.object, contextObject.type, "PostComplete", []);
	}
}