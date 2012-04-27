package persil.core.processor;

class LifecyclePhase 
{
	public inline static var DEFAULT : LifecyclePhase = new LifecyclePhase(-1);
	public inline static var COMPLETE : LifecyclePhase = new LifecyclePhase(1);
	public inline static var POST_COMPLETE : LifecyclePhase = new LifecyclePhase(2);
	
	public var priority(default, null) : Int;

	public function new(priority : Int) 
	{
		this.priority = priority;
	}
}