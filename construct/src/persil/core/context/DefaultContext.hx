package persil.core.context;

import persil.core.extension.Extension;
import persil.reflect.ClassInfo;

import persil.core.util.ReflectUtil;

class DefaultContext implements Context
{
	public var objects : Array<ContextObject>;
	public var config : ContextConfig;
	
	public function new()
	{
		objects = new Array();
		config = new ContextConfig();
	}

	public function addObject(name : String, classInfo : ClassInfo, object : Dynamic) : ContextObject
	{
		var contextObject = new ContextObject(name, classInfo, object);
		objects.push(contextObject);
		
		return contextObject;
	}


	public function getObjectByName(name) : Dynamic
	{
		for(contextObject in objects)
		{
			if (contextObject.name == name)
				return contextObject.object;
		}
		return null;
	}

	public function getObjectByType<T>(type : Class<T>) : Dynamic
	{
		var result = Lambda.filter(objects, getFilterByType(type));
		
		if (result.length == 1)
			return result.first().object;
		else if (result.length > 1)
			throw "Multiple objects of type: " + result.first().classInfo.name + " found";
		else
			return null;
	}
	
	public function getDynamicObjectsByType<T>(type : Class<T>) : List<ContextObject>
	{
		return Lambda.filter(objects, getFilterByType(type));
	}

	public function destroy() : Void
	{
		var extensions : Array<Extension> = config.extensions;

		Lambda.iter(extensions, doDestroyCallOnExtension);
		Lambda.iter(objects, doDestroyCall);

		config.destroy();

		objects = null;
		config = null;
	}
	
	function getFilterByType<T>(type : Class<T>) : ContextObject->Bool
	{
		return function(contextObject : ContextObject) : Bool
		{
			return contextObject.type == type;
		}
	}

	function doDestroyCallOnExtension(extension : Extension)
	{
		extension.destroy();
	}

	function doDestroyCall(contextObject : ContextObject)
	{
		ReflectUtil.callMethodWithMetadata(contextObject.object, contextObject.type, "Destroy", []);
	}
}