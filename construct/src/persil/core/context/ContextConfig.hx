package persil.core.context;

import persil.core.extension.Extension;
import persil.core.processor.LifecycleProcessor;
import persil.core.processor.DefaultLifecycleProcessor;

class ContextConfig 
{
	public var extensions : Array<Extension>;
	public var configClasses : Array<Class<Dynamic>>;
	public var configObjects : Array<Dynamic>;
	public var lifecycleProcessor : LifecycleProcessor;
	
	public function new()
	{
		extensions = new Array<Extension>();
		configClasses = new Array<Class<Dynamic>>();
		configObjects = new Array<Dynamic>();
		lifecycleProcessor = new DefaultLifecycleProcessor();
	}

	public function destroy() : Void
	{
		extensions = null;
		configClasses = null;
		configObjects = null;
		lifecycleProcessor = null;
	}
}