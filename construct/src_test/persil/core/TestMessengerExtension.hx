package persil.core;

import persil.core.context.Context;

import persil.core.extension.messaging.MessengerExtension;
import persil.core.extension.messaging.Messenger;

import massive.munit.Assert;

class TestMessengerExtension 
{
	var context : Context;

	@BeforeClass
	function beforeClass()
	{
		context = ContextBuilder.newBuilder()
			.addExtension(new MessengerExtension())
			.addConfig(TestConfigWithAAndB)
			.build();
	}

	@Test
	function messenger()
	{
		var a : A = context.getObjectByName("a");
		
		Assert.isNotNull(a.messenger);
		Assert.isType(a.messenger, Messenger);
	}

	@Test
	function receivedMessage()
	{
		var a : A = context.getObjectByName("a");
		var b : B = context.getObjectByName("b");

		a.sendMessage();
		
		Assert.areEqual(1, b.messageReceived);
	}
	
	@Test
	function receivedMessageAgain()
	{
		var a : A = context.getObjectByName("a");
		var b : B = context.getObjectByName("b");

		a.sendMessage();
		
		Assert.areEqual(2, b.messageReceived);
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
	@Messenger
	public var messenger : Messenger;

	public function new()
	{
	}

	public function sendMessage() : Void
	{
		messenger.send(new TestMessage());
	}
}

private class B implements haxe.rtti.Infos
{
	public var messageReceived : Int;

	public function new()
	{
		messageReceived = 0;
	}
	
	@Receiver
	public function handleMessage(message : TestMessage) : Void
	{
		messageReceived++;
	}
}

private class TestMessage
{
	public function new() {}
}