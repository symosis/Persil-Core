package persil.core.extension;

import persil.core.context.Context;
import persil.core.context.ContextObject;
import persil.core.extension.Extension;
import persil.core.extension.FrontMessenger;

class MessengerExtension implements Extension 
{
	private var frontMessenger : FrontMessenger;

	public function new()
	{
		frontMessenger = new DefaultFrontMessenger();
	}

	public function process(context : Context) : Void
	{
		var objects : Array<ContextObject> = context.objects;
		
		Lambda.iter(objects, registerMessengerByObjectType);
		Lambda.iter(objects, registerMessengers);
		Lambda.iter(objects, registerReceivers);
	}

	public function destroy() : Void
	{
		
	}

	function registerMessengerByObjectType(contextObject : ContextObject)
	{
		if (Std.is(contextObject.object, Messenger))
		{
			frontMessenger.addMessenger(contextObject.object);
		}
	}

	function registerMessengers(contextObject : ContextObject)
	{
		for (property in contextObject.classInfo.properties)
		{
			if (property.hasMetadata("Messenger"))
			{
				var messenger = new Messenger();
				property.setValue(contextObject.object, messenger);
				
				frontMessenger.addMessenger(messenger);
			}
		}
	}

	function registerReceivers(contextObject : ContextObject)
	{
		for (method in contextObject.classInfo.methods)
		{
			if (method.hasMetadata("Receiver"))
			{
				if (method.parameters.length == 1)
					frontMessenger.addReceiver(contextObject.object, method.name, method.parameters[0].type.type);
				else
					throw "Message: " + contextObject.classInfo.name + "." + method.name + " needs exactly one parameter";
			}
		}		
	}
}