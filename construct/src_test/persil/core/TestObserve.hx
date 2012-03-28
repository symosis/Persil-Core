package persil.core;

import massive.munit.Assert;

import persil.core.extension.ObserverExtension;

class TestObserve
{
	@Test
	function observe()
	{
		var context = ContextBuilder.newBuilder()
			.addExtension(new ObserverExtension())
			.addConfig(TestConfigWithAAndB)
			.build();

		var b : B = context.getObjectByName("b");
		Assert.areEqual(1, b.observeCalledCount);
	}
}

private class TestConfigWithAAndB implements haxe.rtti.Infos
{
	public var a : A;
	public var b : B;

	public function new()
	{
		a = new A();
		b = new B();
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
	public var observeCalledCount : Int;

	public function new()
	{
		observeCalledCount = 0;
	}
	
	@Observe
	public function observe(a : A)
	{
		observeCalledCount++;
	}
}
