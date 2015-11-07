/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_unit","_id","_sessionID"];
_unit = _this select 0;
_id = _this select 1;
_uid = _this select 2;
_name = _this select 3;
if !(_uid in ["", "__SERVER__", "__HEADLESS__"]) then
{
	format["endAccountSession:%1", _uid] call ExileServer_system_database_query_fireAndForget;
	_sessionID = _unit getVariable ["ExileSessionID", ""];
	_sessionID call ExileServer_system_session_end;
	_unit setVariable ["ExileSessionID", nil];
	if !(_unit getVariable ["ExileIsDead", false]) then
	{
		_unit call ExileServer_object_player_database_update;
		deleteVehicle _unit;
	};
};
false