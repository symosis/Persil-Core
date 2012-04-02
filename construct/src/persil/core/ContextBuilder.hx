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

	function buildInternal(configClasses : Array<Class<Dynamic>>)
	{
		var configObjects : Dynamic = context.config.configObjects;
		
		Lambda.iter(configClasses, createObjects);
		Lambda.iter(configObjects, addObjects);

		context.config.lifecycleProcessor.process(context);
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

	function createError(message)
	{
		return "ContextBuilder ERROR: " + message;
	}
}