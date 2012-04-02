package persil.core.processor;

import persil.core.context.Context;


import persil.core.context.Context;
import persil.core.context.ContextObject;
import persil.core.context.DefaultContext;
import persil.core.extension.Extension;

import persil.core.util.ReflectUtil;

class DefaultLifecycleProcessor implements LifecycleProcessor
{
	var context : Context;

	public function new(){}

	public function process(context : Context) : Void
	{
		this.context = context;

		Lambda.iter(context.objects, wireContextObject);
		Lambda.iter(context.config.extensions, processExtension);
		Lambda.iter(context.objects, doCompleteCall);
		Lambda.iter(context.objects, doPostCompleteCall);
	}

	public function processSingleObject(context : Context, contextObject: ContextObject) : Void
	{
		this.context = context;

		wireContextObject(contextObject);
		Lambda.iter(context.config.extensions, processExtension);
		doCompleteCall(contextObject);
		doPostCompleteCall(contextObject);
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