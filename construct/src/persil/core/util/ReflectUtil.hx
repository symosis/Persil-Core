package persil.core.util;

import haxe.rtti.CType;
import haxe.rtti.Meta;

import persil.metadata.Metadata;

class ReflectUtil
{
	public static function callMethodWithMetadata(object : Dynamic, type : Class<Dynamic>, metadataClass : Class<Metadata>, args : Array<Dynamic>) : Dynamic
	{
		var metadata : Metadata = cast Type.createInstance(metadataClass, []);
		var allMetadatas = new Array<Dynamic<Dynamic<Array<Dynamic>>>>();

		var subClassType : Class<Dynamic> = type;

		while(subClassType != null)
		{
			allMetadatas.push(Meta.getFields(subClassType));
			subClassType = Type.getSuperClass(subClassType);
		}

		for(metadatas in allMetadatas)
		{
			for(fieldName in Reflect.fields(metadatas))
			{
				var meta = Reflect.field(metadatas, fieldName);

				if (Reflect.hasField(meta, metadata.identifier))
				{
					return Reflect.callMethod(object, Reflect.field(object, fieldName), []);
				}
			}
		}
		
		return null;
	}
	
	public static function getClassName(object : Dynamic) : String
	{
		return Type.getClassName(Type.getClass(object));
	}
}
