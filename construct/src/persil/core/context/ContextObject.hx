package persil.core.context;

import persil.reflect.ClassInfo;

class ContextObject
{
	public var name : String;
	public var type : Class<Dynamic>;
	public var object : Dynamic;
	public var classInfo : ClassInfo;

	public function new(name, classInfo, object)
	{
		this.name = name;
		this.classInfo = classInfo;
		this.type = classInfo.type;
		this.object = object;
	}
}