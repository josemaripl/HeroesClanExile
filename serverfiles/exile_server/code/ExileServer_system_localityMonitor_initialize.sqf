/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_enabled"];
_enabled = getNumber(configFile >> "CfgSettings" >> "LocalityMonitor" >> "Monitor");
if(_enabled isEqualTo 1)then
{
	[
		120,
		ExileServer_system_LocalityMonitor_thread_monitor,
		[getNumber(configFile >> "CfgSettings" >> "LocalityMonitor" >> "threshold")],
		true
	] 
	call ExileServer_system_thread_addTask;
};