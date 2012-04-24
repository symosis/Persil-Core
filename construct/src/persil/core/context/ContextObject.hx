package persil.core.context;

import persil.reflect.ClassInfo;

import persil.core.processor.LifecyclePhase;

class ContextObject
{
	public var name : String;
	public var type : Class<Dynamic>;
	public var object : Dynamic;
	public var classInfo : ClassInfo;
	public var lifecyclePhase : LifecyclePhase;

	public function new(name, classInfo, object)
	{
		this.name = name;
		this.classInfo = classInfo;
		this.type = classInfo.type;
		this.object = object;
		this.lifecyclePhase = LifecyclePhase.DEFAULT;
	}
}