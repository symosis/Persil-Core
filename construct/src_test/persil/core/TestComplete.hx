package persil.core;

import massive.munit.Assert;

class TestComplete
{
	public static var completeCount;
	public static var postCompleteCount;

	@Before
	function before()
	{
		completeCount = 0;
		postCompleteCount = 0;
	}

	@Test
	function complete()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		Assert.areEqual(1, completeCount);
	}

	@Test
	function postComplete()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		Assert.areEqual(1, postCompleteCount);
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
	function handleContextComplete()
	{
		TestComplete.completeCount++;
	}

	@PostComplete
	function handleContextPostComplete()
	{
		TestComplete.postCompleteCount++;
	}
}
