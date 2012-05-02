package persil.core;

import persil.core.util.ReflectUtil;

import massive.munit.Assert;

class TestReflectUtil
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
	function getClassName()
	{
		var className : String = ReflectUtil.getClassName(new A()); 
		Assert.areEqual("persil.core._TestReflectUtil.A", className);
	}

	@Test
	function postCompleteWasCalledInSubClass()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		Assert.areEqual(1, postCompleteCount);
	}

	@Test
	@Ignore
	function completeWasCalledInBaseClass()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		Assert.areEqual(1, completeCount);
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

private class A extends B
{
	public function new()
	{
		super();
	}

	@PostComplete
	function handleContextPostComplete()
	{
		TestReflectUtil.postCompleteCount++;
	}
}

private class B implements haxe.rtti.Infos
{
	public function new()
	{
	}

	@Complete
	function handleContextComplete()
	{
		TestReflectUtil.completeCount++;
	}
}