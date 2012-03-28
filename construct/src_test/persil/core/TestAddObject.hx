package persil.core;

import massive.munit.Assert;

class TestAddObject
{
	@Test
	function addObject()
	{
		var context = ContextBuilder.newBuilder().addObject(new A()).build();
		
		var a : A = context.getObjectByType(A);
		Assert.isNotNull(a);
	}	

	@Test
	function addObjects()
	{
		var context = ContextBuilder.newBuilder().addObject(new A()).addObject(new B()).build();
		
		var a : A = context.getObjectByType(A);
		Assert.isNotNull(a);

		var b : B = context.getObjectByType(B);
		Assert.isNotNull(b);
	}	
}

private class A implements haxe.rtti.Infos
{
	public function new()
	{
	}
}

private class B implements haxe.rtti.Infos
{
	public function new()
	{
	}
}