package fp.ext
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	// DataStorage
	// This class will create/fetch local data for the application, and get/save key-value 
	//   pairs locally. The keys are Strings while the values can be any Object. 
	//   Multiple DataStorage objects can be created for different data groups.
	// Created by Fletcher, 5/4/13
	public class EXTDataStorage
	{
		private var _sharedObject:SharedObject;
		private var _currentDataKeys:Vector.<String> = null;
		
		// Construct a DataStorage object for this application.
		// "dataGroupName" may be set to differentiate different storage groups.
		public function EXTDataStorage(applicationName:String, dataGroupName:String = "ApplicationData")
		{
			var localDataName:String = applicationName + "-" + dataGroupName;
			_sharedObject = SharedObject.getLocal(localDataName);
			_currentDataKeys = new Vector.<String>();
		}
		
		// Get the current saved value for the given key. Will return undefined 
		//   if the key has not yet been used to save a value.
		public function getValueForKey(key:String):Object
		{
			return _sharedObject.data[key];
		}
		
		// Save the given value for the given key. If the key already exists,
		//   it's value will be overwritten.
		public function saveValueWithKey(key:String, value:Object):void 
		{
			if (isNaN(_sharedObject.data[key]))
				_currentDataKeys.push(key);
			
			_sharedObject.data[key] = value;
			
			this.flushSharedObject();
		}
		
		//TODO - fcole - Test this function
		// Clears all saved values
		public function clearAll():void 
		{
			EXTConsole.debug("DataStorage", "clearAll()", "Clearing saved values... Reload SWF and the values should be \"undefined\".");
			for each (var key:String in _currentDataKeys)
			{
				delete _sharedObject.data[key];
			}
			this.flushSharedObject(); // Needed?
		}
		
		//TODO - fcole - Test this function
		// Clear the saved value for the given key
		public function removeDataForKey(key:String):void
		{
			var value:Object = _sharedObject.data[key];
			if (value == null)
			{
				EXTConsole.info("DataStorage", "removeDataForKey()", "No value for key " + key + " was found");
			}
			else
			{
				EXTConsole.debug("DataStorage", "removeDataForKey()", "Clearing saved value " + value + " for key " + key + "... Reload SWF and the value should be \"undefined\".");
				delete _sharedObject.data[key];
				this.flushSharedObject(); // Needed?
				
				for (var i:int = 0; i < _currentDataKeys.length; ++i)
				{
					var savedKey:String = _currentDataKeys[i];
					if (savedKey == key)
					{
						_currentDataKeys.splice(i, 1);
						break;
					}
				}
			}
		}
		
		// Private helper for writing shared object contents
		private function flushSharedObject():void
		{
			var flushStatus:String = null;
			try 
			{
				flushStatus = _sharedObject.flush(10000);
				
				//TODO - fcole - Is this needed? Maybe only if I dont do the callback checking below???
//				http://www.htmlgoodies.com/beyond/webmaster/projects/article.php/3869531/ActionScript-3-Tutorial-Using-Shared-Objects-to-Show-a-Visitors-Browsing-Time.htm
//				// "The call of close is a must, otherwise you may experience some troubles"
//				_sharedObj.close();
			} 
			catch (error:Error) 
			{
				EXTConsole.error("DataStorage", "saveValueWithKey()", "Flush status error, could not write data");
			}
			
			if (flushStatus != null) 
			{
				switch (flushStatus) 
				{
					case SharedObjectFlushStatus.PENDING:
						EXTConsole.debug("DataStorage", "saveValueWithKey()", "Requesting permission to save object...");
						_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED:
						EXTConsole.debug("DataStorage", "saveValueWithKey()", "Value flushed to disk.");
						break;
				}
			}
		}
		
		// Private helper callback used if the user must give permission 
		//   writing local data.
		private function onFlushStatus(event:NetStatusEvent):void 
		{
//			output.appendText("User closed permission dialog...\n");
			switch (event.info.code) {
				case "SharedObject.Flush.Success":
					EXTConsole.info("DataStorage", "onFlushStatus()", "User granted permission -- value saved.");
					break;
				case "SharedObject.Flush.Failed":
					EXTConsole.info("DataStorage", "onFlushStatus()", "User denied permission -- value not saved.");
					break;
			}
//			output.appendText("\n");
			
			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
	}
}
