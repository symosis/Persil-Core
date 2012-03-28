package persil.core.context;

import persil.core.context.ContextConfig;
import persil.reflect.ClassInfo;

interface Context
{
	var objects : Array<ContextObject>;
	var config : ContextConfig;
	
	function addObject(name : String, classInfo : ClassInfo, object : Dynamic) : ContextObject;
	
	function getObjectByName(name : String) : Dynamic;
	
	function getObjectByType<T>(type : Class<T>) : Dynamic;
	
	function getDynamicObjectsByType<T>(type : Class<T>) : List<ContextObject>;

	function destroy() : Void;
}