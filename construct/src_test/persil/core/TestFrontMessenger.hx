package persil.core;

import massive.munit.Assert;

import persil.core.extension.messaging.FrontMessenger;
import persil.core.extension.messaging.Messenger;

class TestFrontMessenger
{
	public static var receiveCount;

	@Before
	function before()
	{
		receiveCount = 0;
	}

	@Test
	function withMessage2()
	{
		var sendingObject = new CustomSendingObject();
		var receivingObject = new CustomReceivingObject();

		var frontMessenger = new DefaultFrontMessenger();
		frontMessenger.addMessenger(sendingObject);
		frontMessenger.addReceiver(receivingObject, "handleComplete", Message2);

		sendingObject.doSend();

		Assert.areEqual(1, receiveCount);
	}

	@Test
	function noSendWithMessage2()
	{
		var sendingObject = new SendingObject();
		var receivingObject = new CustomReceivingObject();

		var frontMessenger = new DefaultFrontMessenger();
		frontMessenger.addMessenger(sendingObject);
		frontMessenger.addReceiver(receivingObject, "handleComplete", Message2);

		sendingObject.doSend();

		Assert.areEqual(0, receiveCount);
	}
}

private class SendingObject extends Messenger
{
	public function new()
	{
		super();
	}

	public function doSend()
	{
		send(new Message1());
	}
}

private class CustomSendingObject extends Messenger
{
	public function new()
	{
		super();
	}

	public function doSend()
	{
		send(new Message2());
	}
}

private class CustomReceivingObject
{
	public function new()
	{

	}

	public function handleComplete(message : Message2)
	{
		TestFrontMessenger.receiveCount++;
	}
}

private class Message1
{
	public function new(){}
}

private class Message2
{
	public function new(){}
}
