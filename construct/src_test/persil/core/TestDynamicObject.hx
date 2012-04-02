package persil.core;

import persil.core.context.Context;
import persil.core.dynamicobject.DynamicObject;
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
	function chainConfigureShouldFail()
	{
		var e : E = new E();
		var f : F = new F();

		context.addDynamicObject(e);
		context.addDynamicObject(f);
		
		Assert.isNull(e.f);
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

	@Test
	@Ignore
	function triggerInitOnce()
	{
		var g : G = new G();

		var contextOfG = ContextBuilder.newBuilder().addObject(g).build();

		Assert.areEqual(1, H.initTriggered);
		
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

private class E implements haxe.rtti.Infos
{
	@Inject
	public var f : F;

	public function new() {}
}

private class F implements haxe.rtti.Infos
{
	public function new() {}
}

private class G implements haxe.rtti.Infos
{
	@Inject
	public var context : Context;

	public function new() {}

	@Complete
	public function init() 
	{
		context.addDynamicObject(new H());
	}
}

private class H implements haxe.rtti.Infos
{
	public static var initTriggered : Int;

	public function new() 
	{
		H.initTriggered = 0;
	}

	@Complete
	public function init() 
	{
		H.initTriggered++;
	}
}