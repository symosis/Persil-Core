package persil.core;

import persil.core.context.Context;

import massive.munit.Assert;

class TestDestroy
{
	public static var destroyCount;
	public static var extensionDestroyCount;

	@Before
	function before()
	{
		destroyCount = 0;
		extensionDestroyCount = 0;
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

	@Test
	function destroyExtension()
	{
		var context = ContextBuilder.newBuilder()
						.addExtension(new TestableExtension())
						.addConfig(TestConfigWithA).build();
		
		context.destroy();

		Assert.areEqual(1, extensionDestroyCount);
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

private class TestableExtension implements persil.core.extension.Extension
{
	public function new() {}

	public function process(context : Context) : Void
	{
		
	}

	public function destroy() : Void
	{
		TestDestroy.extensionDestroyCount++;
	}
}
