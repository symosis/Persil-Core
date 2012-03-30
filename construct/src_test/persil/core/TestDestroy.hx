package persil.core;

import massive.munit.Assert;

class TestDestroy
{
	public static var destroyCount;

	@Before
	function before()
	{
		destroyCount = 0;
	}

	@Test
	function destroy()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		
		context.destroy();

		Assert.areEqual(1, destroyCount);
		Assert.isNull(context.getObjectByName("a"));
		Assert.areEqual(0, context.objects.length);
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

	@Destroy
	function destroy()
	{
		TestDestroy.destroyCount++;
	}
}
