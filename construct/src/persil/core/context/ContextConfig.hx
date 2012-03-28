package persil.core.context;

import persil.core.extension.Extension;

class ContextConfig 
{
	public var extensions : Array<Extension>;
	public var configClasses : Array<Class<Dynamic>>;
	public var configObjects : Array<Dynamic>;
	
	public function new()
	{
		extensions = new Array<Extension>();
		configClasses = new Array<Class<Dynamic>>();
		configObjects = new Array<Dynamic>();
	}

	public function destroy() : Void
	{
		extensions = null;
		configClasses = null;
		configObjects = null;
	}
}