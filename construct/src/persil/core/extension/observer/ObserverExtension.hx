package persil.core.extension.observer;

import persil.core.context.Context;
import persil.core.context.ContextObject;
import persil.reflect.ClassInfo;

import persil.core.extension.Extension;
import persil.core.extension.observer.metadata.ObserveMetadata;

class ObserverExtension implements Extension 
{
	private var context : Context;
	private var observers : Array<Observer>;
	
	public function new() 
	{
		observers = new Array();
	}

	public function process(context : Context) : Void
	{
		this.context = context;
		var objects : Array<ContextObject> = context.objects;

		Lambda.iter(objects, findObservers);
		Lambda.iter(objects, doObserve);
	}

	public function destroy() : Void
	{
		
	}

	function findObservers(contextObject : ContextObject)
	{
		for (method in contextObject.classInfo.methods)
		{
			if (method.hasMetadata(ObserveMetadata))
			{
				if (method.parameters.length == 1)
					addObserver(contextObject, method.name, method.parameters[0].type);
				else
					throw "Method to observe: " + contextObject.classInfo.name + "." + method.name + " needs exactly one parameter";
			}
		}
	}

	function doObserve(contextObject : ContextObject)
	{
		for(observer in observers)
			observer.observe(contextObject);
	}

	function addObserver(object : ContextObject, methodName : String, type : ClassInfo)
	{
		Log.info(object.classInfo.name, methodName, type.name);
		
		var observer = new Observer();
		observer.object = object;
		observer.methodName = methodName;
		observer.type = type;
		
		observers.push(observer);
	}
}

class Observer
{
	public var object : ContextObject;
	public var methodName : String;
	public var type : ClassInfo;
	
	public function new(){}
	
	public function observe(objectToObserve : ContextObject)
	{
		if (Std.is(objectToObserve.object, type.type))
		{
			Reflect.callMethod(object.object, Reflect.field(object.object, methodName), [objectToObserve.object]);
		}
	}
}