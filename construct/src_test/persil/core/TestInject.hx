package persil.core;

import massive.munit.Assert;

import persil.core.context.Context;

class TestInject
{
	@Test
	function inject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfig).build();

		var a : A = context.getObjectByName("a");
		Assert.isTrue(Std.is(a.b, B));
	}

	@Test
	function injectContext()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfig).build();

		var a : A = context.getObjectByName("a");
		Assert.areEqual(context, a.context);
	}

	@Test
	function circularInject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfig).build();

		var a : A = context.getObjectByName("a");
		Assert.isTrue(Std.is(a.b, B));

		var b : B = context.getObjectByName("b");
		Assert.isTrue(Std.is(b.a, A));
	}
	
	@Test
	function superInject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfig).build();

		var c : C = context.getObjectByName("c");
		Assert.isTrue(Std.is(c.a, A));
	}
}

private class TestConfig implements haxe.rtti.Infos
{
	public var a : A;
	public var b : B;
	public var c : C;

	public function new()
	{
		a = new A();
		b = new B();
		c = new C();
	}
}

private class A implements haxe.rtti.Infos
{
	@Inject
	public var b : B;

	@Inject
	public var context : Context;

	public function new()
	{
	}
}

private class B implements haxe.rtti.Infos
{

	@Inject
	public var a : A;

	public function new()
	{
	}
}

private class C extends B, implements haxe.rtti.Infos
{

}
