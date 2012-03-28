package persil.core;

import massive.munit.Assert;

class TestConfigure
{
	@Test
	function object()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();

		ContextBuilder.newBuilder().configure(new B());

		var b : B = context.getObjectByType(B);
		Assert.isNotNull(b);
	}

	@Test
	function inject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();

		ContextBuilder.newBuilder().configure(new B());

		var b : B = context.getObjectByType(B);
		Assert.isNotNull(b.a);
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
	@Inject
	public var b : B;

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
