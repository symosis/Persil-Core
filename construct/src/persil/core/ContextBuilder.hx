package persil.core;

import persil.reflect.ClassInfo;

import persil.core.context.Context;
import persil.core.context.ContextObject;
import persil.core.context.DefaultContext;
import persil.core.extension.Extension;

import persil.core.util.ReflectUtil;

class ContextBuilder
{
	private static var defaultContext : Context;

	var context : Context;
	
	function new()
	{
		context = new DefaultContext();
	}

	public static function newBuilder() : ContextBuilder
	{
		return new ContextBuilder();
	}

	public function addExtension(extension : Extension) : ContextBuilder
	{
		context.config.extensions.push(extension);

		return this;
	}

	public function addObject(object : Dynamic) : ContextBuilder
	{
		context.config.configObjects.push(object);

		return this;
	}

	public function addConfig(configClass : Class<Dynamic>) : ContextBuilder
	{
		context.config.configClasses.push(configClass);

		return this;
	}

	public function addConfigs(configClasses : Array<Dynamic>) : ContextBuilder
	{
		for (configClass in configClasses) 
			context.config.configClasses.push(configClass);	

		return this;
	}

	public function build() : Context
	{
		defaultContext = context;

		buildInternal(cast context.config.configClasses);
		return defaultContext;
	}
	
	public function configure(object : Dynamic) : Void
	{
		if (defaultContext == null)
			throw createError("Cannot configure Object as no context is available!");

		context = defaultContext;
		configureInternal(object);
	}

	function configureInternal(object : Dynamic)
	{
		var contextObject = context.addObject("configured", ClassInfo.forInstance(object), object);
		configureDynamicObjects(cast [contextObject]);
	}

	function buildInternal(configClasses : Array<Class<Dynamic>>)
	{
		var configObjects : Dynamic = context.config.configObjects;
		
		Lambda.iter(configClasses, createObjects);
		Lambda.iter(configObjects, addObjects);

		configureDynamicObjects(context.objects);
	}

	function createObjects(configClass : Class<Dynamic>)
	{
		var config = Type.createInstance(configClass, []);
		var ci = ClassInfo.forClass(configClass);
		
		addObjectToContext(config, ci);
	}

	function addObjects(configObject : Dynamic)
	{
		var ci = ClassInfo.forInstance(configObject);

		addObjectToContext(configObject, ci);
	}

	function addObjectToContext(config : Dynamic, ci : ClassInfo) : Void
	{
		if (!ci.hasRtti)
		{
			var message = "Config class:" + ci.name + "has no rtti extension - use 'implement haxe.rtti.Infos'";
			throw message;
		}
		
		context.addObject("config", ci, config);
		
		for (property in ci.properties)
		{
			if (property.hasMetadata("Inject"))
				continue;
				
			var instance = property.getValue(config);
			if (instance == null)
			{
				Log.warn("Found property", property.name, "in config", ci.name, "but was null");
			}
			else
			{
				context.addObject(property.name, property.type, instance);
		
				if (property.clazz == Array)
				{
					var list : Array<Dynamic> = cast instance;
					for(listInstance in list)
					{
						context.addObject("dynamic", ClassInfo.forInstance(listInstance), listInstance);
					}
				}
			}
		}
	}

	function configureDynamicObjects(objects : Array<ContextObject>)
	{
		Lambda.iter(objects, wireContextObject);
		Lambda.iter(context.config.extensions, processExtension);
		Lambda.iter(objects, doCompleteCall);
		Lambda.iter(objects, doPostCompleteCall);
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

	function createError(message)
	{
		return "ContextBuilder ERROR: " + message;
	}
}