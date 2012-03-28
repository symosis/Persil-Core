package persil.core;

import massive.munit.Assert;

class TestMultipleConfigs
{
	@Test
	function getObject()
	{
		var context = ContextBuilder.newBuilder().addConfigs([TestConfigWithA, TestConfigWithB]).build();
		var a = context.getObjectByName("a");
		Assert.isNotNull(a);
		var b = context.getObjectByName("b");
		Assert.isNotNull(b);
	}

	@Test
	function injectObjectWithConfig()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithC).addObject(new A()).build();
		
		var c : C = context.getObjectByType(C);
		Assert.isNotNull(c.a);
	}

	@Test
	function injectObjectWithoutConfig()
	{
		var context = ContextBuilder.newBuilder().addObject(new A()).addObject(new C()).build();
		
		var c : C = context.getObjectByType(C);
		Assert.isNotNull(c.a);
	}
}

private class TestConfigWithA implements haxe.rtti.Infos
{
	public var a : A;

	public function new()
	{
		a = new A();
	}
}

private class TestConfigWithB implements haxe.rtti.Infos
{
	public var b : B;

	public function new()
	{
		b = new B();
	}
}

private class TestConfigWithC implements haxe.rtti.Infos
{
	public var c : C;

	public function new()
	{
		c = new C();
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

private class C implements haxe.rtti.Infos
{
	@Inject
	public var a : A;

	public function new() {}
}
