package persil.core.extension;

import persil.core.context.Context;

interface Extension 
{
	function process(context : Context) : Void;

	function destroy() : Void;
}