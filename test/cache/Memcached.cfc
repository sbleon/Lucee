<!--- 
 *
 * Copyright (c) 2016, Lucee Assosication Switzerland. All rights reserved.*
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either 
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 ---><cfscript>
component extends="org.lucee.cfml.test.LuceeTestCase"	{
	
	variables.cacheName='memcached';
	
	//public function afterTests(){}
	
	public function setUp(){
		variables.has=defineCache();
	}

	public boolean function isNotSupported() {
		if(isNull(variables.has)) setUp();
		return !variables.has;
	}

	public void function test() skip="isNotSupported" {
		cachePut(id:'abc', value:'AAA', cacheName:variables.cacheName);
		var val=cacheget(id:'abc', cacheName:variables.cacheName);
		assertEquals("AAA",val);
	}

	private void function testTimespan() skip="isNotSupported" {
		
		var rightNow = Now();
		var testData = {"time": rightNow};
		var cacheId='jkijhiiuhkj';
		 
		// first we store the data
		cachePut(id=cacheId, value=testData, cacheName=variables.cacheName);

		// getting back without waiting on it
		theValue = cacheGet(id=cacheId, cacheName=variables.cacheName);
		wasFound = !isNull(theValue);
		assertTrue(wasFound);

		// getting back after at least a second
		sleep(1500); // take a nap
		theValue = cacheGet(id=cacheId, cacheName=variables.cacheName);
		wasFound = !isNull(theValue);
		assertFalse(wasFound);		
	}

	private string function defineCache(){
		try {
			application action="update" 
				caches="#{memcached:{
						  class: 'org.lucee.extension.io.cache.memcache.MemCacheRaw'
						, bundleName: 'memcached.extension'
						, bundleVersion: '3.0.2.28'
						, storage: false
						, custom: {
							"socket_timeout":"30",
							"initial_connections":"1",
							"alive_check":"true",
							"buffer_size":"1",
							"max_spare_connections":"32",
							"storage_format":"Binary",
							"socket_connect_to":"3",
							"min_spare_connections":"1",
							"maint_thread_sleep":"5",
							"failback":"true",
							"max_idle_time":"600",
							"max_busy_time":"30",
							"nagle_alg":"true",
							"failover":"true",
							"servers":"localhost:11211"
						}
						, default: ''
					}}#";
			cachePut(id='abcd', value=1234, cacheName=variables.cacheName);
			return true;
		}
		catch(e) {}
		return false;
	}

} 
</cfscript>