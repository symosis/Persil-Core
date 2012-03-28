package persil.core;

import massive.munit.Assert;

class TestInjectById
{
	@Test
	function inject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfig).build();

		var a1 : A = context.getObjectByName("a1");
		Assert.areEqual(1, a1.a1.value);
		Assert.areEqual(2, a1.a2.value);
		Assert.areEqual(3, a1.a3.value);
		
		var a2 : A = context.getObjectByName("a2");
		Assert.areEqual(1, a2.a1.value);
		Assert.areEqual(2, a2.a2.value);
		Assert.areEqual(3, a2.a3.value);
		
		var a3 : A = context.getObjectByName("a3");
		Assert.areEqual(1, a3.a1.value);
		Assert.areEqual(2, a3.a2.value);
		Assert.areEqual(3, a3.a3.value);
	}
}

private class TestConfig implements haxe.rtti.Infos
{
	public var a1 : A;
	public var a2 : A;
	public var a3 : A;

	public function new()
	{
		a1 = new A();
		a1.value = 1;
		
		a2 = new A();
		a2.value = 2;
		
		a3 = new A();
		a3.value = 3;
	}
}

private class A implements haxe.rtti.Infos
{
	@Inject
	public var a1 : A;

	@Inject
	public var a3 : A;

	@Inject
	public var a2 : A;
	
	public var value : Int;

	public function new()
	{
	}
}