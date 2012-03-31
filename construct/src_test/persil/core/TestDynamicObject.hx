package persil.core;

import persil.core.context.Context;
import persil.core.context.DynamicObject;
import persil.core.ContextBuilder;

import massive.munit.Assert;

class TestDynamicObject 
{
	var context : Context;

	@Before
	function before()
	{
		var a : A = new A();

		context = ContextBuilder.newBuilder().addObject(a).build();
	}

	@Test
	function addDynamicObject()
	{
		var b : B = new B();

		context.addDynamicObject(b);

		var b2 : B = context.getObjectByType(B);

		Assert.isNotNull(b2);
		Assert.areEqual(b, b2);
	}

	@Test
	function configure()
	{
		var b : B = new B();

		context.addDynamicObject(b);

		Assert.isNotNull(b.a);
		Assert.isType(b.a, A);
	}

	@Test
	function chainConfigure()
	{
		var c : C = new C();
		var b : B = new B();

		context.addDynamicObject(b);
		context.addDynamicObject(c);

		Assert.isNotNull(c.b);
		Assert.isType(c.b, B);
	}

	@Test
	function destroy()
	{
		var d : D = new D();

		var dynamicObject : DynamicObject = context.addDynamicObject(d);

		
		Assert.areEqual(2, context.objects.length);

		dynamicObject.remove();
		
		var d2 : D = context.getObjectByType(D);

		Assert.isNull(d2);

	}
}

private class A implements haxe.rtti.Infos
{
	public function new() {}
}

private class B implements haxe.rtti.Infos
{
	@Inject
	public var a : A;

	public function new() {}
}

private class C implements haxe.rtti.Infos
{
	@Inject
	public var b : B;

	public function new() {}
}

private class D implements haxe.rtti.Infos
{
	@Inject
	public var a : A;

	public function new() {}
}