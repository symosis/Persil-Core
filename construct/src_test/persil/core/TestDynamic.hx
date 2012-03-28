package persil.core;

import massive.munit.Assert;

class TestDynamic
{
	public static var bCount : Int = 0;

	@Before
	function before()
	{
		bCount = 0;
	}

	@Test
	function objects()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithAAndDyanmicBs).build();
		Assert.areEqual(3, bCount);
	}

	@Test
	function listInject()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithAAndDyanmicBs).build();

		var a : A = context.getObjectByType(A);
		Assert.areEqual(3, a.bList.length);
	}
}

private class TestConfigWithAAndDyanmicBs implements haxe.rtti.Infos
{
	public var a : A;

	public var bList : Array<B>;

	public function new()
	{
		a = new A();

		bList = new Array<B>();
		bList.push(new B());
		bList.push(new B());
		bList.push(new B());
	}

}

private class A implements haxe.rtti.Infos
{
	@Inject
	public var bList : Array<B>;

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

	@Complete
	function handleComplete()
	{
		if (a != null)
			TestDynamic.bCount++;
	}
}
