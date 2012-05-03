package persil.core;

import massive.munit.Assert;

class TestParentContext
{
	public static var completeCount : Int;

	@Before
	function before()
	{
		completeCount = 0;
	}

	@Test
	function injectIntoChildContext()
	{
		var parentContext = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var childContext = ContextBuilder.newBuilder().addConfig(TestConfigWithB).parentContext(parentContext).build();

		var b : B = childContext.getObjectByName("b");

		Assert.isNotNull(b.a);
	}

	@Test
	function injectIntoChildContexts()
	{
		var parentContext = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var childContext = ContextBuilder.newBuilder().addConfig(TestConfigWithB).parentContext(parentContext).build();

		var anotherChildContext = ContextBuilder.newBuilder().addConfig(TestConfigWithC).parentContext(childContext).build();

		var b : B = childContext.getObjectByName("b");
		var c : C = anotherChildContext.getObjectByName("c");

		Assert.isNotNull(b.a);
		Assert.areEqual(b.a, c.a);
		Assert.areEqual(c.b, b);
	}

	@Test
	function completeCalledTwice()
	{
		var parentContext = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var childContext = ContextBuilder.newBuilder().addConfig(TestConfigWithB).parentContext(parentContext).build();

		Assert.areEqual(2, completeCount);
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

private class A implements haxe.rtti.Infos
{
	public function new()
	{
	}

	@Complete
	public function handleComplete()
	{
		TestParentContext.completeCount++;
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

private class B implements haxe.rtti.Infos
{
	@Inject
	public var a : A;

	public function new()
	{
	}

	@Complete
	public function handleComplete()
	{
		TestParentContext.completeCount++;
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

private class C implements haxe.rtti.Infos
{
	@Inject
	public var a : A;

	@Inject
	public var b : B;

	public function new()
	{
	}
}