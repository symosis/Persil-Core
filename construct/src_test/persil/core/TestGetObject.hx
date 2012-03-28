package persil.core;

import massive.munit.Assert;

class TestGetObject
{
	@Test
	function getObjectByName()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var a = context.getObjectByName("a");
		Assert.isNotNull(a);
	}

	@Test
	function getObjectByNameValidate()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var a : A = context.getObjectByName("a");
		Assert.isTrue(Std.is(a, A));
		Assert.isTrue(a.getValue());
	}

	@Test
	function getObjectByType()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithA).build();
		var a : A = context.getObjectByType(A);
		Assert.isNotNull(a);
	}

	@Test
	function getObjectAAndBByName()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithAAndB).build();

		var a : A = context.getObjectByName("a");
		Assert.isTrue(Std.is(a, A));

		var b : B = context.getObjectByName("b");
		Assert.isTrue(Std.is(b, B));
	}

	@Test
	function getObjectAAndBByType()
	{
		var context = ContextBuilder.newBuilder().addConfig(TestConfigWithAAndB).build();

		var a : A = context.getObjectByType(A);
		Assert.isTrue(Std.is(a, A));

		var b : B = context.getObjectByType(B);
		Assert.isTrue(Std.is(b, B));
	}

	@Test
	@Ignore
	function getObjectAAndBByTypeC()
	{
		
		Assert.isTrue(false);
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

private class A
{
	private var value : Bool;

	public function new()
	{
		value = true;
	}

	public function getValue()
	{
		return value;
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

private class B
{
	public function new()
	{
	}
}
